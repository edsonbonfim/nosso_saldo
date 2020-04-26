import 'package:flutter/material.dart';

class PlaceholderContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const PlaceholderContainer({
    Key key,
    @required this.width,
    this.height = 10,
    this.color = const Color(0xff536180),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height),
      ),
    );
  }
}
