import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final dio = Dio(BaseOptions(
    baseUrl: "https://api.nossosaldo.life",
  ));

  String get token {
    return Hive.box("settings").get("token");
  }

  Future<void> deleteToken() async {
    if (!hasToken()) return;
    return Hive.box("settings").delete("token");
  }

  Future<void> persistToken(String token) async {
    return Hive.box("settings").put("token", token);
  }

  bool hasToken() {
    return Hive.box("settings").containsKey("token");
  }

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    var response = await dio.post("/sessions", data: {
      "email": username,
      "password": password,
    });

    if (response.statusCode != 200) {
      throw FormatException(response.statusMessage);
    }

    if (response.data["err"] != null || response.data["token"] == null) {
      throw FormatException(
        response.data["err"] ?? "Ocorreu um erro, tente novamente",
      );
    }

    return response.data["token"];
  }

  Future<String> signup({
    @required String name,
    @required String email,
    @required String password,
  }) async {
    var response = await dio.post("/user/create", data: {
      "name": name,
      "email": email,
      "password": password,
    });

    if (response.statusCode != 200) {
      throw FormatException(response.statusMessage);
    }

    if (response.data["err"] != null || response.data["message"] == null) {
      throw FormatException(
        response.data["err"] ?? "Ocorreu um erro, tente novamente",
      );
    }

    return response.data["message"];
  }

  void addAuthorizationHeader() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) =>
          options..headers[HttpHeaders.authorizationHeader] = "Bearer " + token,
    ));
  }

  Future<String> inviteFriend({@required String emailToInvite}) async {
    addAuthorizationHeader();

    var response = await dio.post('/friendRequest/add', data: {
      "emailToInvite": emailToInvite,
    });

    if (response.statusCode != 200) {
      throw new FormatException(response.statusMessage);
    }

    if (response.data["err"] != null || response.data["message"] == null) {
      throw FormatException(
        response.data["err"] ?? "Ocorreu um erro, tente novamente",
      );
    }

    return response.data["message"];
  }
}
