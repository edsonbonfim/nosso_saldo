import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/authentication/authentication_bloc.dart';
import '../../controllers/list_friends/list_friends_bloc.dart';
import '../../controllers/list_friends/list_friends_event.dart';
import '../../controllers/list_friends/list_friends_state.dart';
import '../../models/friend.dart';
import '../../shared/custom_card.dart';
import '../../shared/friend_tile.dart';
import '../friendy/friend_page.dart';

class ListFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ListFriendsBloc()
        ..add(
          ListFriendsFetch(
            token: BlocProvider.of<AuthenticationBloc>(context)
                .userRepository
                .token,
          ),
        ),
      child: BlocBuilder<ListFriendsBloc, ListFriendsState>(
        builder: (context, state) {
          if (state is ListFriendsLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ListFriendsError) {
            return Text(state.message);
          }
          if (state is ListFriendsSuccess) {
            return _list(context, state.friends);
          }
          if (state is ListFriendsEmpty) {
            return _empty(context);
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return CustomCard(
      title: "Amigos",
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        child: Text(
          "Convide algum usuário para iniciar",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _list(BuildContext context, List<Friend> friends) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.secondary,
        boxShadow: [BoxShadow(color: const Color(0xff19203F))],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Amigos",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: const Color(0xffC3DEED),
            ),
          ),
          SizedBox(height: 10),
          ListView.separated(
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemCount: friends.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) => FriendTile(
              friend: friends[index],
              contentPadding: EdgeInsets.zero,
              onTap: () => _onTap(context, friends[index]),
            ),
          ),
        ],
      ),
    );
  }

  _onTap(BuildContext context, Friend friend) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FriendPage(friend: friend)),
    );
  }
}
