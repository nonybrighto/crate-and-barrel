import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  final Color productColor;
  final bool isSelected;
  final VoidCallback onPressed;
  const ColorButton({
    Key? key,
    required this.productColor,
    this.isSelected = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: productColor,
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
      ),
      onTap: onPressed,
    );
  }
}
