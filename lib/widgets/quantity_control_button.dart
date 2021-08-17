import 'package:crate_and_barrel/constants.dart';
import 'package:flutter/material.dart';

class QuantityControlButton extends StatelessWidget {
  final bool isIncrement;
  final VoidCallback onPressed;
  const QuantityControlButton({
    Key? key,
    required this.isIncrement,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xffdedee3), width: 1),
          ),
          child: Icon(
            isIncrement ? Icons.add : Icons.remove,
            color: kTextDarkColor,
          ),
        ),
        onTap: onPressed,
      ),
    );
  }
}
