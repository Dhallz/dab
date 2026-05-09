import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../auth_state.dart';
import 'auth_text_field.dart';

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
  void didUpdateWidget(covariant AuthForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.email != _emailController.text) {
      _emailController.text = widget.state.email;
    }
    if (widget.state.password != _passwordController.text) {
      _passwordController.text = widget.state.password;
    }
    if (widget.state.name != _nameController.text) {
      _nameController.text = widget.state.name;
    }
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
    final isLoading = widget.state.status.isLoading;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.state.isLogin ? l10n.authWelcomeBack : l10n.authCreateAccount,
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
          label: Text(l10n.authSignInWithSso),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: Divider(color: Colors.white.withValues(alpha: 0.1)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.commonOr,
                style: TextStyle(
                  color: const Color(0xFF94A3B8).withValues(alpha: 0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: Colors.white.withValues(alpha: 0.1)),
            ),
          ],
        ),
        const SizedBox(height: 24),

        if (!widget.state.isLogin) ...[
          AuthTextField(
            label: l10n.authLabelName,
            hint: l10n.authHintName,
            icon: Icons.person_outline,
            controller: _nameController,
            onChanged: widget.onNameChanged,
          ),
          const SizedBox(height: 16),
        ],

        AuthTextField(
          label: l10n.authLabelEmail,
          hint: l10n.authHintEmail,
          icon: Icons.email_outlined,
          controller: _emailController,
          onChanged: widget.onEmailChanged,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        AuthTextField(
          label: l10n.authLabelPassword,
          hint: l10n.commonPasswordMaskHint,
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
                  widget.state.isLogin ? l10n.authSignIn : l10n.authRegister,
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
                ? l10n.authToggleRegister
                : l10n.authToggleSignIn,
            style: TextStyle(
              color: const Color(0xFF94A3B8).withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}
