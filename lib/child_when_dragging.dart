import 'package:flutter/material.dart';
import 'package:flutter_dock/constants.dart';

class ChildWhenDragging extends StatelessWidget {
  const ChildWhenDragging({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: iconSize, end: 0),
      duration: Duration(milliseconds: 300),
      builder: (context, value, _) {
        return SizedBox(width: value, height: value);
      },
    );
  }
}
