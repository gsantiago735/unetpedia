import 'package:flutter/material.dart';
import 'package:unetpedia/core/constants/constant_colors.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.controller,
    this.onChange,
  });

  final String? hintText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChange,
      textCapitalization: TextCapitalization.sentences,
      decoration: _decoration(),
      //style: TextStyle(),
    );
  }

  InputDecoration _decoration() {
    return InputDecoration(
      isDense: true,
      filled: true,
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFFAFAFAF),
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(
        prefixIcon,
        size: 24,
        color: ConstantColors.cff141718,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color.fromARGB(255, 219, 222, 227)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color.fromARGB(255, 219, 222, 227)),
      ),
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      constraints: const BoxConstraints(),
    );
  }
}
