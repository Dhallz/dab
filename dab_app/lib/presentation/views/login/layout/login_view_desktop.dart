import 'package:flutter/material.dart';

class LoginViewDesktop extends StatelessWidget {
  const LoginViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          Expanded(child: Center(child: Text('Login Desktop - Left Side'))),
          Expanded(
            child: Center(child: Text('Login Desktop - Right Side Form')),
          ),
        ],
      ),
    );
  }
}
