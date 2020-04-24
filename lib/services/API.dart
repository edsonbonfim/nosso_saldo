import 'dart:io';

import 'package:dio/dio.dart';

import '../controllers/list_friends/list_friends_state.dart';
import '../controllers/transaction/transaction_state.dart';
import '../models/friend.dart';
import '../models/transaction.dart';

class APIService {
  Dio dio;

  APIService() {
    dio = Dio(BaseOptions(
      baseUrl: "https://api.nossosaldo.life",
    ));
  }

  Future<ListFriendsState> getFriends(String token) async {
    try {
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) => options
          ..headers[HttpHeaders.authorizationHeader] = "Bearer " + token,
      ));

      var response = await dio.get("/balance");

      if (response.statusCode != 200) {
        return ListFriendsError(message: response.statusMessage);
      }

      if (response.data["err"] != null) {
        return ListFriendsError(message: response.data["err"]);
      }

      if (response.data["empty"] != null) {
        return ListFriendsEmpty();
      }

      var rawFriends = response.data["formattedData"] as List;

      return ListFriendsSuccess(
        friends: rawFriends.map((friend) => Friend.fromJson(friend)).toList(),
      );
    } on Exception catch (ex) {
      return ListFriendsError(message: ex.toString());
    }
  }

  Future<TransactionState> getTransactions(
    String token,
    String friendId,
  ) async {
    try {
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) => options
          ..headers[HttpHeaders.authorizationHeader] = "Bearer " + token,
      ));

      var response = await dio.get("/balance/historic/$friendId");

      if (response.statusCode != 200) {
        return TransactionError(message: response.statusMessage);
      }

      if (response.data["err"] != null) {
        return TransactionError(message: response.data["err"]);
      }

      var rawTransactions = response.data["payload"] as List;

      return TransactionSuccess(
        transactions:
            rawTransactions.map((t) => Transaction.fromJson(t)).toList(),
      );
    } on Exception catch (ex) {
      return TransactionError(message: ex.toString());
    }
  }
}
