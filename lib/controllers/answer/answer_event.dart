import 'package:meta/meta.dart';

enum Answers { accept, reject }

abstract class AnswerEvent {}

class SendAnswer extends AnswerEvent {
  SendAnswer({
    @required this.email,
    @required this.answer,
  });

  final String email;
  final Answers answer;
}
