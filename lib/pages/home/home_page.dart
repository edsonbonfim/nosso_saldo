import 'package:flutter/material.dart';

import 'list_friends.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 20),
      child: ListFriends(),
    );
  }
}
