import 'package:flutter/material.dart';

class ContactsAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Nosso Saldo"),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
