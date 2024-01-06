import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_type/result_type.dart';
import 'package:shelter_booking/login/data/login_data.dart';
import 'package:shelter_booking/login/entity/user.dart';

class LoginRepository {
  final LoginData _loginData;

  LoginRepository({
    required loginData,
  }) : _loginData = loginData;

  Future<Result<void, String>> loginUser(String email, String password) async {
    try {
      return Success(await _loginData.loginUserByEmail(email, password));
    } on FirebaseAuthException catch (error) {
      return Failure(error.code);
    }
  }

  Future<Result<void, dynamic>> registerUser(
    String email,
    String password,
    String name,
  ) async {
    try {
      return Success(await _loginData.registerUser(
        email,
        password,
        name,
      ));
    } catch (e) {
      return Failure(e);
    }
  }

  Future<Result<AppUser?, dynamic>> getCurrentUser() async {
    try {
      return Success(await _loginData.getCurrentUser());
    } catch (e) {
      return Failure(e);
    }
  }

  Future<Result<void, dynamic>> resetPassword(String email) async {
    try {
      return Success(await _loginData.resetPassword(email));
    } catch (e) {
      return Failure(e);
    }
  }
}
