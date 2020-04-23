import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final Widget child;

  const CustomCard({
    Key key,
    this.title,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 20, 12, 90),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.secondary,
        boxShadow: [BoxShadow(color: const Color(0xff19203F))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: const Color(0xffC3DEED),
            ),
          ),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
