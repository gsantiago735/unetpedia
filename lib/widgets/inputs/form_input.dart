import 'package:flutter/material.dart';
import 'package:unetpedia/core/constants/constant_colors.dart';

class FormInput extends StatelessWidget {
  const FormInput({
    super.key,
    this.hintText,
    this.labelText = "Label",
    this.obscureText = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    required this.textInputType,
    this.validator,
    this.onChange,
    this.onPressed,
  });

  final String? hintText;
  final String labelText;
  final bool obscureText;
  final bool readOnly;
  final IconData? prefixIcon;
  final Widget? suffixIcon;

  final TextEditingController? controller;
  final TextInputType textInputType;

  final void Function(String)? onChange;
  final String? Function(String?)? validator;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFAFAFAF),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: onChange,
          obscureText: obscureText,
          validator: validator,
          keyboardType: textInputType,
          onTap: onPressed,
          readOnly: readOnly,
          textCapitalization: TextCapitalization.sentences,
          decoration: _decoration(),
          //style: TextStyle(),
        ),
      ],
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
      prefixIcon: (prefixIcon != null)
          ? Icon(prefixIcon, size: 24, color: ConstantColors.cff141718)
          : null,
      suffixIcon: suffixIcon,
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: ConstantColors.cff141718),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: ConstantColors.cff141718),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Colors.red),
      ),
      errorMaxLines: 2,
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Colors.red),
      ),
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      constraints: const BoxConstraints(),
    );
  }
}
