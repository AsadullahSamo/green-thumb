import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;

  const CustomTextfield({
    Key? key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
    required this.icon,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Attach controller to TextFormField
      obscureText: obscureText, // Control obscuring text (password fields)
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator, // Attach validator
    );
  }
}
