part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  loading,
  wrongPassword,
  userNotExisting,
  userRegistered,
  userLoggedIn,
  resetEmailPasswordSent,
  success,
  failure,
}

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(LoginStatus.initial) status,
    AppUser? currentUser
  }) = _LoginState;
}
