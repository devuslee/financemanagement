import 'package:flutter/material.dart';

class ReusablePasswordTextField extends StatefulWidget {
  final String labelText;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator; // Add validator parameter

  ReusablePasswordTextField({
    required this.labelText,
    required this.icon,
    required this.controller,
    this.validator, // Include validator parameter in constructor
  });

  @override
  _ReusablePasswordTextFieldState createState() => _ReusablePasswordTextFieldState();
}

class _ReusablePasswordTextFieldState extends State<ReusablePasswordTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField( // Change to TextFormField
      controller: widget.controller,
      obscureText: !_isPasswordVisible,
      enableSuggestions: false,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon, color: Colors.grey),
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      validator: widget.validator, // Assign validator parameter
    );
  }
}
