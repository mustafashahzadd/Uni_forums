import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forum_firebase_pkg/forum_firebase_pkg.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  AuthBloc({required this.repo}) : super(AuthStateInitial()) {
    on<AuthCheckEvent>(_onCheck);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthSignOutEvent>(_onSignOut);
  }

  void _onCheck(AuthCheckEvent event, Emitter<AuthState> emit) {
    final user = repo.currentUser;
    if (user != null) {
      emit(AuthStateAuthenticated(email: user.email ?? ''));
    } else {
      emit(AuthStateUnauthenticated());
    }
  }

  Future<void> _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthStateLoading());
    try {
      final cred = await repo.signUp(email: event.email, password: event.password);
      emit(AuthStateAuthenticated(email: cred.user?.email ?? ''));
    } catch (e) {
      emit(AuthStateFailure(error: e.toString()));
    }
  }

  Future<void> _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthStateLoading());
    try {
      final cred = await repo.signIn(email: event.email, password: event.password);
      emit(AuthStateAuthenticated(email: cred.user?.email ?? ''));
    } catch (e) {
      emit(AuthStateFailure(error: e.toString()));
    }
  }

  Future<void> _onSignOut(AuthSignOutEvent event, Emitter<AuthState> emit) async {
    await repo.signOut();
    emit(AuthStateUnauthenticated());
  }
}
