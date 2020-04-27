import 'package:bloc/bloc.dart';

import '../authentication/authentication.dart';
import 'answer_event.dart';
import 'answer_state.dart';

class AnswerInviteBloc extends Bloc<AnswerInviteEvent, AnswerInviteState> {
  final AuthenticationBloc authentication;

  AnswerInviteBloc(this.authentication);

  @override
  AnswerInviteState get initialState => InitialAnswer();

  @override
  Stream<AnswerInviteState> mapEventToState(AnswerInviteEvent event) async* {
    if (event is SendAnswer) {
      yield SendingAnswer();

      try {
        var message = await authentication.repository.answerInvite(
          email: event.email,
          invite: event.invite,
        );

        yield SendedAnswer(message);
      } on FormatException catch (ex) {
        yield UnsendedAnswer(ex.message);
      } on Exception {
        yield UnsendedAnswer("Ocorreu um erro, tente novamente mais tarde");
      }
    }
  }
}
