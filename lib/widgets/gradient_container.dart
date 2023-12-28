import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  const GradientContainer({super.key, required this.child, });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.deepPurple,
          Colors.purple,
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: child,
    );
  }
}
