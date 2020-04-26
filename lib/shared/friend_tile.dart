import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';

import '../models/friend.dart';
import 'placeholder_container.dart';

class ContactTile extends StatelessWidget {
  const ContactTile(
    this.contact, {
    Key key,
    this.onTap,
    this.showImage = true,
  }) : super(key: key);

  final Contact contact;
  final VoidCallback onTap;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    String message;
    String myBalance = r"R$ " +
        (contact.myBalance < 0 ? contact.myBalance * -1 : contact.myBalance)
            .toStringAsFixed(2);
    Color color = const Color(0xffC3DEED);

    if (contact.myBalance < 0) {
      message = "Você deve $myBalance";
      color = Theme.of(context).colorScheme.primary;
    } else if (contact.myBalance > 0) {
      message = "Seu crédito é de $myBalance";
      color = const Color(0xff8EF6B1);
    } else {
      message = "Ninguém deve ninguém";
      color = const Color(0xffC3DEED);
    }

    return ListTile(
      onTap: onTap,
      leading: !showImage
          ? null
          : CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              backgroundImage:
                  AssetImage("assets/images/placeholder-avatar.jpg"),
            ),
      title: Text(
        contact.name,
        style: TextStyle(
          fontSize: 14,
          color: const Color(0xffC3DEED),
        ),
      ),
      subtitle: Text(
        message,
        style: TextStyle(
          fontSize: 13,
          color: color,
        ),
      ),
    );
  }

  static Widget placeholderList(
    BuildContext context, {
    @required int itemCount,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, _) => placeholder(context),
      itemCount: itemCount,
    );
  }

  static Widget placeholder(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundImage: AssetImage("assets/images/placeholder-avatar.jpg"),
      ),
      title: Wrap(children: [
        PlaceholderContainer(
          width: 80,
          height: 12,
        ),
      ]),
      subtitle: Wrap(children: [
        PlaceholderContainer(
          width: 200,
          height: 10,
        ),
      ]),
    );
  }
}
