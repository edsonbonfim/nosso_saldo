import 'package:dio/dio.dart';

class APIService {
  Dio dio;

  APIService() {
    dio = Dio(BaseOptions(
      baseUrl: "https://api.nossosaldo.life",
    ));
  }

  // Future<ListFriendState> getFriends(String token) async {
  //   try {
  //     dio.interceptors.add(InterceptorsWrapper(
  //       onRequest: (RequestOptions options) => options
  //         ..headers[HttpHeaders.authorizationHeader] = "Bearer " + token,
  //     ));

  //     var response = await dio.get("/balance");

  //     if (response.statusCode != 200) {
  //       return ListFriendStateError(message: response.statusMessage);
  //     }

  //     if (response.data["err"] != null) {
  //       return ListFriendStateError(message: response.data["err"]);
  //     }

  //     var rawFriends = response.data["formattedData"] as List;

  //     return ListFriendStateSuccess(
  //       friends: rawFriends.map((friend) => Friend.fromJson(friend)).toList(),
  //     );
  //   } catch (ex) {
  //     return ListFriendStateError(message: ex.toString());
  //   }
  // }
}
