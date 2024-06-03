import 'package:flutter/material.dart';
import 'package:unetpedia/core/constants/constant_colors.dart';

class GenericButton extends StatelessWidget {
  final String text;
  final Color color;
  final EdgeInsets? padding;
  final VoidCallback onTap;

  const GenericButton({
    super.key,
    required this.text,
    this.padding,
    this.color = ConstantColors.cff141718,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: padding,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          minimumSize: const MaterialStatePropertyAll(Size(0, 48)),
          shape: const MaterialStatePropertyAll(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
          ),
          backgroundColor: MaterialStatePropertyAll(color),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
