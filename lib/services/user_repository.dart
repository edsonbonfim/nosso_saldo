import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../controllers/list_friends/list_friends_state.dart';
import '../controllers/list_invites/list_invites_bloc.dart';
import '../models/friend.dart';
import '../models/transaction.dart';

class UserRepository {
  static final url = "https://api.nossosaldo.life";

  String get token {
    var bearer = Hive.box<String>("settings").get("token");
    return "Bearer $bearer";
  }

  Future<void> deleteToken() async {
    if (!hasToken()) return;
    return Hive.box<String>("settings").delete("token");
  }

  Future<void> persistToken(String token) async {
    return Hive.box<String>("settings").put("token", token);
  }

  bool hasToken() {
    return Hive.box<String>("settings").containsKey("token");
  }

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    var response = await http.post(
      "$url/sessions",
      body: jsonEncode({
        "email": username,
        "password": password,
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: token,
      },
    );

    var data = jsonDecode(response.body) as Map;

    if (data["err"] != null || data["token"] == null) {
      throw FormatException(
        data["err"] ?? "Ocorreu um erro, tente novamente",
      );
    }

    return data["token"];
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
        HttpHeaders.authorizationHeader: token,
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
        HttpHeaders.authorizationHeader: token,
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

  Future<List<Friend>> getInvites() async {
    var response = await http.get('$url/friendRequest/get', headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if (response.contentLength == 0) {
      return <Friend>[];
    }

    var data = jsonDecode(response.body) as Map;

    var rawFriends = data["payload"] as List;

    return rawFriends.map((friend) => Friend.fromJson(friend)).toList();
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
        HttpHeaders.authorizationHeader: token,
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

  Future<ListFriendsState> getFriends() async {
    var response = await http.get("$url/balance", headers: {
      HttpHeaders.authorizationHeader: token,
    });

    var data = jsonDecode(response.body);

    if (data["err"] != null) {
      return ListFriendsError(message: data["err"]);
    }

    if (data["empty"] != null) {
      return ListFriendsEmpty();
    }

    var rawFriends = data["formattedData"] as List;

    return ListFriendsSuccess(
      friends: rawFriends.map((friend) => Friend.fromJson(friend)).toList(),
    );
  }

  Future<List<Transaction>> getTransactions(
    String token,
    String friendId,
  ) async {
    var response = await http.get("$url/balance/historic/$friendId", headers: {
      HttpHeaders.authorizationHeader: token,
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
