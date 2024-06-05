import 'package:clicksoutlet/constants/style.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String value)? onChange;
  final String? Function(String?)? validator;
  final bool readOnly;

  const InputWidget({
    required this.label,
    this.controller,
    this.onChange,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        onChanged: onChange,
        controller: controller,
        validator: validator,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: ColorsConst.primary,
              width: 2.0,
            ),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelStyle: const TextStyle(color: ColorsConst.third),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: ColorsConst.primary,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
