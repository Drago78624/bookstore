import 'package:flutter/material.dart';

class SeeAllBtn extends StatelessWidget {
  const SeeAllBtn({super.key, required this.onTap});

  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTap(1);
      },
      child: Text(
        "See all",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
