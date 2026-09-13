import 'package:flutter/material.dart';

import 'layouts/auth_view_mobile.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const AuthViewMobile();
      },
    );
  }
}
