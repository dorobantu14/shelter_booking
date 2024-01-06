import 'package:flutter/material.dart';

class SquareRoundedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Color color;

  const SquareRoundedButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      child: icon,
    );
  }
}
