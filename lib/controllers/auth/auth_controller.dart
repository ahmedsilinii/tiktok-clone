import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> signInAnonymously() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).signInAnonymously();
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

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email, password);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }

    
  }
}
