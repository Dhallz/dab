import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_icons.dart';
import '../auth_state.dart';
import 'auth_text_field.dart';

class AuthForm extends StatefulWidget {
  final AuthState state;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onApiBaseChanged;
  final VoidCallback onSubmitted;
  final VoidCallback onModeToggled;

  /// When true (system already bootstrapped), self-registration is closed on
  /// the API, so the register toggle is hidden and only login is offered.
  final bool isSystemConfigured;

  const AuthForm({
    super.key,
    required this.state,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onNameChanged,
    required this.onApiBaseChanged,
    required this.onSubmitted,
    required this.onModeToggled,
    this.isSystemConfigured = true,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  late final TextEditingController _apiBaseController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.state.email);
    _passwordController = TextEditingController(text: widget.state.password);
    _nameController = TextEditingController(text: widget.state.name);
    _apiBaseController = TextEditingController(text: widget.state.apiBase);
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
    if (widget.state.apiBase != _apiBaseController.text) {
      _apiBaseController.text = widget.state.apiBase;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _apiBaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.state.status.isLoading;
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.state.isLogin ? l10n.authWelcomeBack : l10n.authCreateAccount,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(AppIcons.building, size: 20),
          label: Text(l10n.authSignInWithSso),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.commonOr,
                style: TextStyle(
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        AuthTextField(
          label: l10n.authLabelApiUrl,
          hint: l10n.authHintApiUrl,
          icon: AppIcons.providers,
          controller: _apiBaseController,
          onChanged: widget.onApiBaseChanged,
          keyboardType: TextInputType.url,
          autocorrect: false,
          enableSuggestions: false,
        ),
        const SizedBox(height: 16),
        if (!widget.state.isLogin) ...[
          AuthTextField(
            label: l10n.authLabelName,
            hint: l10n.authHintName,
            icon: AppIcons.profile,
            controller: _nameController,
            onChanged: widget.onNameChanged,
          ),
          const SizedBox(height: 16),
        ],
        AuthTextField(
          label: l10n.authLabelEmail,
          hint: l10n.authHintEmail,
          icon: AppIcons.email,
          controller: _emailController,
          onChanged: widget.onEmailChanged,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        AuthTextField(
          label: l10n.authLabelPassword,
          hint: l10n.commonPasswordMaskHint,
          icon: AppIcons.lock,
          obscureText: true,
          controller: _passwordController,
          onChanged: widget.onPasswordChanged,
        ),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: isLoading ? null : widget.onSubmitted,
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: scheme.onPrimary,
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
        if (!widget.isSystemConfigured) ...[
          const SizedBox(height: 16),
          TextButton(
            onPressed: isLoading ? null : widget.onModeToggled,
            child: Text(
              widget.state.isLogin
                  ? l10n.authToggleRegister
                  : l10n.authToggleSignIn,
            ),
          ),
        ],
      ],
    );
  }
}
