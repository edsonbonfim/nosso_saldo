import 'package:flutter/material.dart';

import '../models/models.dart';
import 'placeholder_container.dart';

class ContactTile extends StatelessWidget {
  const ContactTile(
    this.contact, {
    Key key,
    this.onTap,
    this.sublabel,
    this.showImage = true,
  }) : super(key: key);

  final Contact contact;
  final VoidCallback onTap;
  final String sublabel;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: contact.myBalance,
      builder: (context, value, child) {
        String message;
        Color color = const Color(0xffC3DEED);

        if (sublabel != null) {
          message = sublabel;
        } else {
          String myBalance =
              r"R$ " + (value < 0 ? value * -1 : value).toStringAsFixed(2);

          if (value < 0) {
            message = "Você deve $myBalance";
            color = Theme.of(context).colorScheme.primary;
          } else if (value > 0) {
            message = "Seu crédito é de $myBalance";
            color = const Color(0xff8EF6B1);
          } else {
            message = "Ninguém deve ninguém";
          }
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
      },
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
