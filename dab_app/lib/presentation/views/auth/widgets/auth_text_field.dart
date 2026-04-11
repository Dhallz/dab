import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFF8FAFC),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xFF94A3B8).withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
            filled: true,
            fillColor: const Color(0xFF0F172A).withValues(alpha: 0.3),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF6366F1),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}
