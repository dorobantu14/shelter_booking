import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String userId,
    required String name,
  }) = _User;



  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}