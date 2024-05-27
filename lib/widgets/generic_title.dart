import 'package:flutter/material.dart';
import 'package:unetpedia/core/constants/constant_colors.dart';

class GenericTitle extends StatelessWidget {
  const GenericTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: const BoxDecoration(
        color: ConstantColors.cff141718,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Text(
        title,
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
