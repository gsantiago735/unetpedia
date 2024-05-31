import 'package:flutter/material.dart';
import 'package:unetpedia/core/constants/constant_colors.dart';

class GenericIconButton extends StatelessWidget {
  const GenericIconButton({super.key, required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 24,
      //visualDensity: VisualDensity.compact,
      color: ConstantColors.cff141718,
      style: ButtonStyle(
        backgroundColor: const MaterialStatePropertyAll(Colors.white),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(width: 2, color: Color(0xFFD9D9D9)),
        )),
      ),
    );
  }
}
