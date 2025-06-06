import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/controllers/auth/auth_controller.dart';
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (user) {
          if (user == null) {
            return LoginScreen();
          }
          return Text(
            'Home Screen\nWelcome, ${user.displayName}!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
          );
        },
      ),
    );
  }
}
