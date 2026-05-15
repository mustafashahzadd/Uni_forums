import 'package:firebase_auth/firebase_auth.dart';

/// ABSTRACT class = contract/interface
/// Defines WHAT auth operations exist — not HOW they work.
/// This is the Repository Pattern your PDF covers.
///
/// WHY abstract? So we can swap Firebase with anything else
/// (or a Mock in tests) without changing the rest of the app.
abstract class AuthRepository {
  /// Sign up with email & password
  Future<UserCredential> signUp({
    required String email,
    required String password,
  });

  /// Sign in with email & password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  });

  /// Sign out current user
  Future<void> signOut();

  /// Get currently logged in user
  User? get currentUser;

  /// Stream that emits whenever auth state changes
  Stream<User?> get authStateChanges;
}
