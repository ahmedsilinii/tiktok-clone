import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/models/auth/user_model.dart';
import 'package:tiktok_clone/core/providers/firebase_providers.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._auth, this._firestore);

  Future<void> _createUserProfile(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<AppUser?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return AppUser.fromFirebase(user);
    });
  }

  Future<void> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      await _createUserProfile(userCredential.user!);
    } catch (e) {
      throw Exception('Failed to sign in anonymously: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _createUserProfile(userCredential.user!);
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String username,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      print('User created: ${user.uid}');
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'displayName': username,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Firestore write attempted for ${user.uid}');
    } catch (e, st) {
      print('Failed to sign up: $e\n$st');
      throw Exception('Failed to sign up: $e');
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(firebaseAuthProvider),
    ref.read(firestoreProvider),
  );
});
