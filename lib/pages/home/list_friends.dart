import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/contacts/contacts_bloc.dart';
import '../../controllers/contacts/contacts_state.dart';
import '../../models/friend.dart';
import '../../shared/friend_tile.dart';
import '../../shared/toogle.dart';

class ListFriends extends StatelessWidget {
  static int itemCount;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactsBloc, ContactsState>(
      listener: _blocListener,
      child: BlocBuilder<ContactsBloc, ContactsState>(
        builder: _blocBuilder,
      ),
    );
  }

  void _blocListener(BuildContext context, ContactsState state) {
    if (state is UnloadedContacts) {
      Toogle.show(context: context, label: state.message);
    }
  }

  Widget _blocBuilder(BuildContext context, ContactsState state) {
    if (state is UnloadedContacts) return SizedBox();
    return _mapStateToWidget(context, state);
  }

  Widget _mapStateToWidget(BuildContext context, state) {
    if (state is LoadingContacts) {
      return ContactTile.placeholderList(
        context,
        itemCount: itemCount ?? 1,
      );
    }

    if (state is EmptyContacts) {
      return _empty(context);
    }

    if (state is LoadedContacts) {
      itemCount = state.contacts.length;
      return _listFriends(state.contacts);
    }

    return SizedBox();
  }

  Widget _listFriends(List<Contact> friends) {
    return ListView.builder(
      itemCount: friends.length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) => ContactTile(
        friends[index],
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

  _onTap(BuildContext context, Contact friend) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => FriendPage(friend: friend)),
    // );
  }
}
