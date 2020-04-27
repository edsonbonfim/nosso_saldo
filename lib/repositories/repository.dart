import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../controllers/controllers.dart';
import '../models/models.dart';
import '../models/user.dart';

class UserRepository {
  static final url = "https://api.nossosaldo.life";

  User get user {
    return Hive.box("settings").get("user") as User;
  }

  Future<void> persistUser(User user) async {
    return Hive.box("settings").put("user", user);
  }

  Future<User> authenticate({
    @required String email,
    @required String password,
  }) async {
    var response = await http.post(
      "$url/sessions",
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var data = jsonDecode(response.body) as Map;

    if (data["err"] != null || data["token"] == null) {
      throw FormatException(
        data["err"] ?? "Ocorreu um erro, tente novamente",
      );
    }

    return User(
      name: data["name"],
      email: email,
      token: data["token"],
    );
  }

  Future<String> signup({
    @required String name,
    @required String email,
    @required String password,
  }) async {
    var response = await http.post(
      "$url/user/create",
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer ${user.token}",
      },
    );

    var data = jsonDecode(response.body) as Map;

    if (data["err"] != null || data["message"] == null) {
      throw FormatException(
        data["err"] ?? "Ocorreu um erro, tente novamente",
      );
    }

    return data["message"];
  }

  Future<String> inviteFriend({@required String emailToInvite}) async {
    var response = await http.post(
      '$url/friendRequest/add',
      body: jsonEncode({
        "emailToInvite": emailToInvite,
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer ${user.token}",
      },
    );

    var data = jsonDecode(response.body) as Map;

    if (data["err"] != null || data["message"] == null) {
      throw FormatException(
        data["err"] ?? "Ocorreu um erro, tente novamente",
      );
    }

    return data["message"];
  }

  Future<List<Contact>> getInvites() async {
    var response = await http.get('$url/friendRequest/get', headers: {
      HttpHeaders.authorizationHeader: "Bearer ${user.token}",
    });

    if (response.contentLength == 0) {
      return <Contact>[];
    }

    var data = jsonDecode(response.body) as Map;

    var rawFriends = data["payload"] as List;

    return rawFriends.map((friend) => Contact.fromJson(friend)).toList();
  }

  Future<String> answerInvite({
    @required String email,
    @required Invites invite,
  }) async {
    var response = await http.put(
      "$url/friendRequest/update",
      body: jsonEncode({
        invite == Invites.accept ? "emailAccepted" : "emailRejected": email,
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer ${user.token}",
      },
    );

    var data = jsonDecode(response.body) as Map;

    if (data["err"] != null || data["message"] == null) {
      throw FormatException(
        data["err"] ?? "Ocorreu um erro, tente novamente",
      );
    }

    return data["message"];
  }

  Future<List<Contact>> getContacts() async {
    var response = await http.get("$url/balance", headers: {
      HttpHeaders.authorizationHeader: "Bearer ${user.token}",
    });

    var data = jsonDecode(response.body);

    if (data["err"] != null) {
      throw FormatException(data["err"]);
    }

    if (data["empty"] != null) {
      return <Contact>[];
    }

    var rawFriends = data["formattedData"] as List;

    return rawFriends.map((friend) => Contact.fromJson(friend)).toList();
  }

  Future<List<Transaction>> getTransactions(String friendId) async {
    var response = await http.get("$url/balance/historic/$friendId", headers: {
      HttpHeaders.authorizationHeader: "Bearer ${user.token}",
    });

    var data = jsonDecode(response.body);

    if (data["err"] != null) {
      if (data["err"] == "Vazio") {
        return <Transaction>[];
      }

      throw FormatException(data["err"]);
    }

    var rawTransactions = data["payload"] as List;

    return rawTransactions.map((t) => Transaction.fromJson(t)).toList();
  }
}
