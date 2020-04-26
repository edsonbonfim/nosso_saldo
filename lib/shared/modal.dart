import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';

import 'btn.dart';
import 'input.dart';

class Modal extends StatelessWidget {
  final RubberAnimationController controller;
  final String label;
  final String sublabel;
  final List<Input> inputs;
  final Btn btn;

  const Modal({
    Key key,
    @required this.controller,
    @required this.label,
    this.sublabel,
    @required this.inputs,
    @required this.btn,
  })  : assert(controller != null),
        assert(label != null),
        assert(inputs != null && inputs.length > 0),
        assert(btn != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kBottomNavigationBarHeight / 2),
          topRight: Radius.circular(kBottomNavigationBarHeight / 2),
        ),
      ),
      child: ListView(
        physics: ScrollPhysics(),
        children: [
          SizedBox(
            height: controller.upperBoundValue.pixel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _push,
                _title,
                sublabel != null ? _subtitle : SizedBox(),
                ...inputs,
                btn
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _push {
    return Center(
      child: Container(
        width: 50,
        height: 3,
        decoration: BoxDecoration(
          color: const Color(0xff536180),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  Widget get _title {
    return Text(
      label,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: const Color(0xffC3DEED),
      ),
    );
  }

  Widget get _subtitle {
    return Text(
      sublabel,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w300,
        color: const Color(0xffC3DEED),
      ),
    );
  }
}
