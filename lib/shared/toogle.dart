import 'package:flutter/material.dart';

class Toogle {
  static void show({
    @required BuildContext context,
    @required String label,
    bool success = false,
  }) {
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(
          label,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: success
            ? const Color(0xff8EF6B1)
            : Theme.of(context).colorScheme.primary,
        action: SnackBarAction(
          label: "Fechar",
          onPressed: () {
            Scaffold.of(context).removeCurrentSnackBar();
          },
          textColor: Colors.white,
        ),
      ));
  }
}
