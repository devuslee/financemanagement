import 'package:flutter/material.dart';

class ReusableEmailTextField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator; // Add validator parameter

  ReusableEmailTextField({
    required this.labelText,
    required this.icon,
    required this.controller,
    this.validator, // Include validator parameter in constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField( // Change to TextFormField
      controller: controller,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: validator, // Assign validator parameter
    );
  }
}
