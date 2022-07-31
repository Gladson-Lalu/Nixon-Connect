part of 'auth_cubit.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

//initial state
class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  String toString() => 'AuthInitial';
}

//loading state
class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  String toString() => 'AuthLoading';
}

//Loaded state
class AuthLoaded extends AuthState {
  final UserModel user;
  const AuthLoaded({required this.user});

  @override
  String toString() => 'AuthLoaded';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthLoaded &&
          runtimeType == other.runtimeType &&
          user == other.user;

  @override
  int get hashCode => user.hashCode;
}

//error state
class AuthError extends AuthState {
  final String error;
  const AuthError({required this.error});

  @override
  String toString() => 'AuthError';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthError &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}
