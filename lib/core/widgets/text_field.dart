import 'package:flutter/material.dart';
import 'package:shelter_booking/core/core.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final FormFieldValidator<String>? validator;
  final Color? fillColor;
  final double borderRadius;
  final Color? borderColor;

  const AppTextField({
    Key? key,
    required this.hintText,
    this.obscureText,
    this.suffixIcon,
    required this.controller,
    this.onChanged,
    this.maxLines,
    this.validator,
    this.fillColor,
    required this.borderRadius,
    this.borderColor,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText ?? false,
      validator: validator,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor ?? AppColors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: borderColor ?? Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        filled: true,
        fillColor: fillColor ?? AppColors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor ?? AppColors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
