import 'package:bloc/bloc.dart';

import '../controllers.dart';

class AnswerBloc extends Bloc<AnswerEvent, AnswerState> {
  AnswerBloc(this.invitesBloc, this.contactsBloc);

  final InvitesBloc invitesBloc;
  final ContactsBloc contactsBloc;

  AuthenticationBloc get authenticationBloc => contactsBloc.authenticationBloc;

  @override
  AnswerState get initialState => InitialAnswer();

  @override
  Stream<AnswerState> mapEventToState(AnswerEvent event) async* {
    if (event is SendAnswer) {
      yield SendingAnswer();

      try {
        var message = await authenticationBloc.repository.answerInvite(
          email: event.email,
          invite: event.answer,
        );

        yield SendedAnswer(message);

        invitesBloc.onRefresh();
        contactsBloc.onRefresh();
      } on FormatException catch (ex) {
        yield UnsendedAnswer(ex.message);
      } on Exception {
        yield UnsendedAnswer("Ocorreu um erro, tente novamente mais tarde");
      }

      yield InitialAnswer();
    }
  }

  void sendAnswer(String email, Answers answer) {
    add(SendAnswer(email: email, answer: answer));
  }
}
