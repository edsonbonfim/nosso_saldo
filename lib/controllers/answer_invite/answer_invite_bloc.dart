import 'package:bloc/bloc.dart';

import '../authentication/authentication_bloc.dart';
import 'answer_invite_event.dart';
import 'answer_invite_state.dart';

class AnswerInviteBloc extends Bloc<AnswerInviteEvent, AnswerInviteState> {
  final AuthenticationBloc authentication;

  AnswerInviteBloc(this.authentication);

  @override
  AnswerInviteState get initialState => AnswerInviteInitial();

  @override
  Stream<AnswerInviteState> mapEventToState(AnswerInviteEvent event) async* {
    if (event is AnswerInvite) {
      yield AnswerInviteLoading();

      try {
        var message = await authentication.repository.answerInvite(
          email: event.email,
          invite: event.invite,
        );

        yield AnswerInviteSuccess(message: message);
      } on FormatException catch (ex) {
        yield AnswerInviteError(message: ex.message);
      } on Exception {
        yield AnswerInviteError(
          message: "Ocorreu um erro, tente novamente mais tarde",
        );
      }
    }
  }
}
