import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../widgets.dart';

class ContactsInvites extends StatefulWidget {
  @override
  _ContactsInvitesState createState() => _ContactsInvitesState();
}

class _ContactsInvitesState extends State<ContactsInvites> {
  AnswerBloc answerBloc;

  @override
  void initState() {
    super.initState();
    answerBloc = AnswerBloc(
      context.bloc<InvitesBloc>(),
      context.bloc<ContactsBloc>(),
    );
  }

  @override
  void dispose() {
    answerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: answerBloc,
      listener: _answerBlocListener,
      child: BlocBuilder<InvitesBloc, InvitesState>(
        builder: _inviteBlocBuilder,
      ),
    );
  }

  void _answerBlocListener(BuildContext context, AnswerState state) {
    if (state is AnswerStateMessage) {
      Toogle.show(
        context: context,
        label: state.message,
        success: state is SendedAnswer,
      );
    }
  }

  Widget _inviteBlocBuilder(BuildContext context, InvitesState state) {
    if (state is LoadedInvites) {
      return _loadedInvites(state.contacts);
    }

    return SizedBox();
  }

  Widget _loadedInvites(List<Contact> contacts) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          color: context.scaffoldBackgroundColor,
          child: Text(
            "SOLICITAÇÕES",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        _listInvites(contacts),
      ],
    );
  }

  Widget _listInvites(List<Contact> contacts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: contacts.length,
      itemBuilder: (context, i) => _inviteItemBuilder(context, contacts[i]),
    );
  }

  Widget _inviteItemBuilder(BuildContext context, Contact contact) {
    return ContactTile(
      contact,
      sublabel: contact.email,
      onTap: () => _showModalActionSheet(contact),
    );
  }

  Future<void> _showModalActionSheet(Contact contact) async {
    var answer = await showModalActionSheet<Answers>(
      context: context,
      title: contact.name,
      message: contact.email,
      style: AdaptiveStyle.material,
      actions: <SheetAction<Answers>>[
        SheetAction(
          key: Answers.accept,
          label: "Aceitar",
        ),
        SheetAction(
          key: Answers.reject,
          label: "Recusar",
        ),
      ],
    );
    answerBloc.sendAnswer(contact.email, answer);
  }
}
