import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String label;
  final Widget child;

  const CustomCard({
    Key key,
    this.label,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Theme.of(context).colorScheme.secondary,
      child: child,
    );
  }
}
