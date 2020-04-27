import 'package:build_context/build_context.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../shared/friend_tile.dart';

class ContactAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Contact contact;

  const ContactAppBar(this.contact, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: ContactTile(
        contact,
        showImage: context.isPhone,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
