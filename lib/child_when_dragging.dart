import 'package:flutter/material.dart';

class ChildWhenDragging extends StatelessWidget {
  const ChildWhenDragging({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 48, end: 0),
      duration: Duration(milliseconds: 300),
      builder: (context, value, _) {
        return SizedBox(width: value, height: value);
      },
    );
  }
}
