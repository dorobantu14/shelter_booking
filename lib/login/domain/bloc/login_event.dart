part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.loginUserByEmail({
    required String email,
    required String password,
  }) = _LoginUserEvent;

  const factory LoginEvent.registerUser({
    required String name,
    required String email,
    required String password,
  }) = _RegisterUserEvent;

  const factory LoginEvent.resetPassword({
    required String email,
  }) = _ResetPasswordEvent;
}
