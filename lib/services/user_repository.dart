import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final dio = Dio(BaseOptions(
    baseUrl: "https://api.nossosaldo.life",
  ));

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    final response = await dio.post("/sessions", data: {
      "email": username,
      "password": password,
    });

    if (response.statusCode != 200) {
      throw FormatException(response.statusMessage);
    }

    if (response.data["err"] != null) {
      throw FormatException(response.data["err"]);
    }

    return response.data["token"];
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
}
