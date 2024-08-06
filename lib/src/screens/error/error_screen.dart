import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sonat_hrm_rewarded/src/screens/login/login_screen.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Screen Not Found"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go(LoginScreen.routeName),
          child: const Text("Back to login Screen"),
        ),
      ),
    );
  }
}
