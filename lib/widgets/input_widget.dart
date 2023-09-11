import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final String hintText;
  final String labelText;
  final bool required;
  final TextEditingController controller;
  final Widget icon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  const InputWidget({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    required this.icon,
    required this.obscureText,
    required this.required,
    this.validator,
    this.suffixIcon,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  String? _validator(String? value) {
    if (widget.required && (value == null || value.isEmpty)) {
      if (widget.validator != null) {
        return widget.validator!(value);
      }
      return 'Please input ${widget.labelText}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      validator: _validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        fillColor: Colors.white,
        filled: true,
        labelText: widget.labelText,
        prefixIcon: widget.icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}
