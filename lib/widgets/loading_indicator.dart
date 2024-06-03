import 'package:flutter/material.dart';
import 'package:unetpedia/core/constants/constant_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator(
      {super.key, this.value, this.color = ConstantColors.cff141718});

  final double? value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: value,
      strokeWidth: 4,
      color: color,
      //backgroundColor: Colors.yellow,
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }
}
