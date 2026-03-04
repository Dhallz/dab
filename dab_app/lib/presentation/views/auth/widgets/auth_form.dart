import 'package:flutter/material.dart';
import '../auth_state.dart';

class AuthForm extends StatefulWidget {
  final AuthState state;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onSubmitted;
  final VoidCallback onModeToggled;

  const AuthForm({
    super.key,
    required this.state,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onNameChanged,
    required this.onSubmitted,
    required this.onModeToggled,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.state.email);
    _passwordController = TextEditingController(text: widget.state.password);
    _nameController = TextEditingController(text: widget.state.name);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.state.status == AuthViewStatus.loading;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.state.isLogin ? 'Welcome Back' : 'Create Account',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF8FAFC),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // SSO Button
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.business_outlined, size: 20),
          label: const Text('Sign in with Company SSO'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withOpacity(0.2)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: TextStyle(
                  color: const Color(0xFF94A3B8).withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
          ],
        ),
        const SizedBox(height: 24),

        if (!widget.state.isLogin) ...[
          _AuthTextField(
            label: 'Name',
            hint: 'Your full name',
            icon: Icons.person_outline,
            controller: _nameController,
            onChanged: widget.onNameChanged,
          ),
          const SizedBox(height: 16),
        ],

        _AuthTextField(
          label: 'Email',
          hint: 'you@company.com',
          icon: Icons.email_outlined,
          controller: _emailController,
          onChanged: widget.onEmailChanged,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        _AuthTextField(
          label: 'Password',
          hint: '••••••••',
          icon: Icons.lock_outline,
          obscureText: true,
          controller: _passwordController,
          onChanged: widget.onPasswordChanged,
        ),
        const SizedBox(height: 32),

        ElevatedButton(
          onPressed: isLoading ? null : widget.onSubmitted,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  widget.state.isLogin ? 'Sign In' : 'Register',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 16),

        TextButton(
          onPressed: isLoading ? null : widget.onModeToggled,
          child: Text(
            widget.state.isLogin
                ? "Don't have an account? Register"
                : "Already have an account? Sign In",
            style: TextStyle(color: const Color(0xFF94A3B8).withOpacity(0.8)),
          ),
        ),
      ],
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  const _AuthTextField({
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
              color: const Color(0xFF94A3B8).withOpacity(0.5),
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
            filled: true,
            fillColor: const Color(0xFF0F172A).withOpacity(0.3),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
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
