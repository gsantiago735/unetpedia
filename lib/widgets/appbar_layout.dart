import 'package:flutter/material.dart';
import 'package:unetpedia/core/constants/constant_colors.dart';

class AppBarLayout extends StatelessWidget {
  const AppBarLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: const BoxDecoration(
        color: ConstantColors.cff141718,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: child,
    );
  }
}
