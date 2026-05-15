import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

/// CONCRETE implementation of AuthRepository using Firebase.
/// If we ever switch from Firebase, we only change THIS file.
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) => _auth.createUserWithEmailAndPassword(email: email, password: password);

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) => _auth.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
