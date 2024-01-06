import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelter_booking/core/strings/strings.dart';
import 'package:shelter_booking/login/domain/repository/login_repository.dart';
import 'package:shelter_booking/login/entity/user.dart';

part 'login_event.dart';

part 'login_state.dart';

part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LoginRepository loginRepository)
      : _repository = loginRepository,
        super(const LoginState()) {
    on<_LoginUserEvent>(_onLoginByEmail);
    on<_RegisterUserEvent>(_onRegister);
    on<_ResetPasswordEvent>(_onResetPassword);
  }

  final LoginRepository _repository;

  Future<void> setLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Strings.isLoggedInText, isLoggedIn);
  }

  Future<void> _onLoginByEmail(
      _LoginUserEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _repository.loginUser(event.email, event.password);
    if (result.isSuccess) {
      setLoginState(true);
      final currentUser = await _repository.getCurrentUser();
      if (currentUser.isSuccess) {
        emit(state.copyWith(
          status: LoginStatus.userLoggedIn,
          currentUser: currentUser.success,
        ));
      }
    } else if (result.isFailure) {
      if (result.failure == Strings.invalidCredentialsText) {
        emit(state.copyWith(status: LoginStatus.userNotExisting));
      }
    }
  }

  Future<void> _onRegister(
      _RegisterUserEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _repository.registerUser(
      event.email,
      event.password,
      event.name,
    );

    if (result.isSuccess) {
      emit(state.copyWith(status: LoginStatus.userRegistered));
    } else {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }

  FutureOr<void> _onResetPassword(
      _ResetPasswordEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _repository.resetPassword(event.email);

    if (result.isSuccess) {
      emit(state.copyWith(status: LoginStatus.resetEmailPasswordSent));
    } else {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }
}
