import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/core/utils/utils.dart';
import 'package:tiktok_clone/models/auth/user_model.dart';
import 'package:tiktok_clone/repositories/auth/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<AppUser?>>((ref) {
      return AuthController(ref);
    });

class AuthController extends StateNotifier<AsyncValue<AppUser?>> {
  final Ref ref;
  AuthController(this.ref) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    state = const AsyncValue.loading();
    try {
      ref.read(authRepositoryProvider).authStateChanges.listen((user) {
        state = AsyncValue.data(user);
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signInAnonymously(BuildContext context) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).signInAnonymously();
      // ignore: use_build_context_synchronously
      showSnackBar(context, "Signed in anonymously");
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).signOut();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty || password.isEmpty) {
      showSnackBar(context, 'Please fill in all fields.');
      state = AsyncValue.error('Fields cannot be empty', StackTrace.current);
      return;
    }
    if (!emailRegex.hasMatch(email)) {
      showSnackBar(context, 'Please enter a valid email address.');
      state = AsyncValue.error('Invalid email format', StackTrace.current);
      return;
    }
    state = const AsyncValue.loading();
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email, password);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signUp(
    BuildContext context,
    String email,
    String password,
    String username,
  ) async {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      showSnackBar(context, 'Please fill in all fields.');
      state = AsyncValue.error('Fields cannot be empty', StackTrace.current);
      return;
    }
    if (!emailRegex.hasMatch(email)) {
      showSnackBar(context, 'Please enter a valid email address.');
      state = AsyncValue.error('Invalid email format', StackTrace.current);
      return;
    }
    state = const AsyncValue.loading();
    try {
      await ref
          .read(authRepositoryProvider)
          .signUp(email, password, username);
      // ignore: use_build_context_synchronously
      showSnackBar(context, "Account created successfully");
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
