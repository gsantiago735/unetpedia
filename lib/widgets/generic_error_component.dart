import 'package:flutter/material.dart';

class GenericErrorComponent extends StatelessWidget {
  const GenericErrorComponent(
      {super.key, this.error = "Ha ocurrido un error."});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Text(error);
  }
}
