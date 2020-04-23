import 'package:meta/meta.dart';

class TransactionEvent {}

class TransactionFetch extends TransactionEvent {
  final String friendId;

  TransactionFetch({@required this.friendId});
}
