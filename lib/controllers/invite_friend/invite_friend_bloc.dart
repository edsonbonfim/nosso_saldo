import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../authentication/authentication_bloc.dart';
import 'invite_friend_event.dart';
import 'invite_friend_state.dart';

class InviteFriendBloc extends Bloc<InviteFriendEvent, InviteFriendState> {
  final AuthenticationBloc authenticationBloc;

  InviteFriendBloc({@required this.authenticationBloc});

  @override
  InviteFriendState get initialState => InviteFriendInitial();

  @override
  Stream<InviteFriendState> mapEventToState(InviteFriendEvent event) async* {
    yield InviteFriendLoading();

    if (event is InviteFriend) {
      try {
        var message = await authenticationBloc.userRepository.inviteFriend(
          emailToInvite: event.emailToInvite,
        );
        yield InviteFriendSuccess(message: message);
      } on FormatException catch (ex) {
        yield InviteFriendError(message: ex.message);
      } on DioError catch (ex) {
        yield InviteFriendError(message: ex.message);
      } on Exception {
        yield InviteFriendError(message: "Ocorreu um erro, tente novamente!");
      }
    }
  }
}
