import 'package:flutter/material.dart';
import 'package:nosso_saldo/models/friend.dart';

class FriendTile extends StatelessWidget {
  final Friend friend;
  final VoidCallback onTap;
  final EdgeInsets contentPadding;

  const FriendTile(
      {Key key, @required this.friend, this.onTap, this.contentPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message;
    String myBalance = r"R$ " +
        (friend.myBalance < 0 ? friend.myBalance * -1 : friend.myBalance)
            .toStringAsFixed(2);
    Color color = const Color(0xffC3DEED);

    if (friend.myBalance < 0) {
      message = "Você deve $myBalance";
      color = Theme.of(context).colorScheme.primary;
    } else if (friend.myBalance > 0) {
      message = "Seu crédito é de $myBalance";
      color = const Color(0xff8EF6B1);
    } else {
      message = "Nínguem deve ningém";
      color = Colors.white;
    }

    return ListTile(
      contentPadding: contentPadding,
      onTap: onTap,
      leading: Hero(
        tag: friend.id,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          backgroundImage: AssetImage("assets/images/placeholder-avatar.jpg"),
        ),
      ),
      title: Text(
        friend.name,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: const Color(0xffC3DEED),
        ),
      ),
      subtitle: Text(
        message,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: onTap == null
          ? null
          : Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xffC3DEED),
            ),
    );
  }
}
