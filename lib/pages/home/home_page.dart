import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/answer_invite/answer_invite_bloc.dart';
import '../../controllers/authentication/authentication_bloc.dart';
import '../../controllers/list_friends/list_friends_bloc.dart';
import '../../controllers/list_friends/list_friends_event.dart';
import '../../controllers/list_invites/list_invites_bloc.dart';
import '../../controllers/list_invites/list_invites_event.dart';
import 'list_friends.dart';
import 'list_invites.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthenticationBloc authentication;
  ListFriendsBloc listFriends;
  ListInvitesBloc listInvites;

  @override
  void initState() {
    super.initState();

    authentication = BlocProvider.of<AuthenticationBloc>(context);

    listFriends = ListFriendsBloc(authenticationBloc: authentication)
      ..add(FetchFriends());

    listInvites = ListInvitesBloc(authenticationBloc: authentication)
      ..add(FetchInvites());
  }

  @override
  void dispose() {
    listFriends.close();
    listFriends.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListFriendsBloc>.value(
      value: listFriends,
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.white,
        onRefresh: () {
          listFriends.add(FetchFriends());
          listInvites.add(FetchInvites());
          return Future.delayed(Duration());
        },
        child: ListView(
          padding: EdgeInsets.only(top: 20),
          children: [
            BlocProvider(
              create: (context) => AnswerInviteBloc(
                BlocProvider.of<AuthenticationBloc>(context),
              ),
              child: BlocProvider<ListInvitesBloc>.value(
                value: listInvites,
                child: ListInvites(),
              ),
            ),
            ListFriends(),
          ],
        ),
      ),
    );
  }
}
