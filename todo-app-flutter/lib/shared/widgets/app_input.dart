import 'package:flutter/material.dart';

class AppInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final Function(String)? onChanged;

  const AppInput({
    super.key,
    required this.controller,
    required this.label,
    this.obscure = false,
    this.onChanged,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        setState(() {
          isFocused = value;
        });
      },
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscure,
        onChanged: widget.onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: isFocused ? Colors.blueAccent : Colors.white54,
          ),
          filled: true,
          fillColor: const Color(0xFF020617),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.blueAccent,
            ),
          ),
        ),
        cursorColor: Colors.blueAccent,
      ),
    );
  }
}