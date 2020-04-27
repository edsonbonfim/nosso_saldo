import 'package:flutter/material.dart';

import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../widgets.dart';

class ListInvites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AnswerInviteBloc, AnswerInviteState>(
      listener: _listenAnswerInvite,
      child: BlocBuilder<InvitesBloc, InvitesState>(
        builder: _blocBuilder,
      ),
    );
  }

  void _listenAnswerInvite(BuildContext context, AnswerInviteState state) {
    if (state is AnswerInviteStateMessage) {
      Toogle.show(
        context: context,
        label: state.message,
        success: state is SendedAnswer,
      );
    }
  }

  Widget _blocBuilder(BuildContext context, InvitesState state) {
    if (state is LoadedInvites) {
      return _listInvites(context, state.friends);
    }

    return SizedBox();
  }

  Widget _listInvites(BuildContext context, List<Contact> friends) {
    return CustomCard(
      label: "Convites",
      child: ListView.separated(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: friends.length,
        itemBuilder: (_, index) => _invite(context, friends[index]),
        separatorBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Divider(height: 1),
        ),
      ),
    );
  }

  Widget _invite(BuildContext context, Contact friend) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            backgroundImage: AssetImage("assets/images/placeholder-avatar.jpg"),
          ),
          title: Text(
            friend.name,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: const Color(0xffC3DEED),
            ),
          ),
          subtitle: Text(
            friend.email,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: const Color(0xffC3DEED),
              fontSize: 12,
            ),
          ),
        ),
        _actions(context, friend: friend),
      ],
    );
  }

  _actions(BuildContext context, {@required Contact friend}) {
    return Row(
      children: [
        _btn(
          context,
          label: "Aceitar",
          color: const Color(0xff8EF6B1),
          onPressed: () {
            context.bloc<AnswerInviteBloc>().add(SendAnswer(
                  email: friend.email,
                  invite: Invites.accept,
                ));
          },
        ),
        _btn(
          context,
          label: "Recusar",
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            context.bloc<AnswerInviteBloc>().add(SendAnswer(
                  email: friend.email,
                  invite: Invites.reject,
                ));
          },
        ),
      ],
    );
  }

  _btn(
    BuildContext context, {
    @required String label,
    @required Color color,
    @required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}