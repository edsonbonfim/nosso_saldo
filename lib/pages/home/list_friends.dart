import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/list_friends/list_friends_bloc.dart';
import '../../controllers/list_friends/list_friends_state.dart';
import '../../models/friend.dart';
import '../../shared/friend_tile.dart';
import '../../shared/toogle.dart';
import '../friendy/friend_page.dart';

class ListFriends extends StatelessWidget {
  static int itemCount;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListFriendsBloc, ListFriendsState>(
      listener: _blocListener,
      child: BlocBuilder<ListFriendsBloc, ListFriendsState>(
        builder: _blocBuilder,
      ),
    );
  }

  void _blocListener(BuildContext context, ListFriendsState state) {
    if (state is ListFriendsError) {
      Toogle.show(context: context, label: state.message);
    }
  }

  Widget _blocBuilder(BuildContext context, ListFriendsState state) {
    if (state is ListFriendsError) return SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: const Color(0xff19203F),
          ),
        ],
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
          _mapStateToWidget(context, state),
        ],
      ),
    );
  }

  Widget _mapStateToWidget(BuildContext context, state) {
    if (state is ListFriendsLoading) {
      return FriendTile.placeholderList(
        context,
        itemCount: itemCount ?? 1,
      );
    }

    if (state is ListFriendsEmpty) {
      return _empty(context);
    }

    if (state is ListFriendsSuccess) {
      itemCount = state.friends.length;
      return _listFriends(state.friends);
    }

    return SizedBox();
  }

  Widget _listFriends(List<Friend> friends) {
    return ListView.separated(
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
    );
  }

  Widget _empty(BuildContext context) {
    return Container(
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
    );
  }

  _onTap(BuildContext context, Friend friend) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FriendPage(friend: friend)),
    );
  }
}
