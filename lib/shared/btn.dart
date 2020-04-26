import 'package:flutter/material.dart';

class Btn extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const Btn({
    Key key,
    @required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Theme.of(context).colorScheme.primary.withAlpha(230),
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withAlpha(230),
          ],
        ),
        boxShadow: [BoxShadow(color: const Color(0xff19203F))],
      ),
      child: FlatButton(
        onPressed: onPressed,
        textColor: Colors.white,
        disabledTextColor: Colors.white,
        child: onPressed != null
            ? Text(label)
            : SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
