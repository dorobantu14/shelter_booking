import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shelter_booking/core/functions/convert_map.dart';
import 'package:shelter_booking/login/entity/user.dart';

class LoginData {
  final FirebaseDatabase _database;

  LoginData({
    required database,
  }) : _database = database;

  Future<AppUser> getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    var userId = currentUser?.uid;
    var usersRef = _database.ref('users');
    final response = await usersRef.child(userId!).get();
    Map<Object?, Object?> originalMap = response.value as Map<dynamic, dynamic>;
    originalMap['userId'] = userId;
    Map<String, dynamic> convertedMap = convertMap(originalMap);

    return AppUser.fromJson(convertedMap);
  }

  Future<void> loginUserByEmail(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) async {
    });
  }

  Future<void> registerUser(
    String email,
    String password,
    String name,
  ) async {
    final auth = FirebaseAuth.instance;
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      final user = userCredential.user;
      final uid = user!.uid;
      final userdata = {
        'name': name,
      };
      _database.ref('users').child(uid).set(userdata);
    });
  }

  Future<void> resetPassword(String email) async {
    final auth = FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(email: email);
  }
}
