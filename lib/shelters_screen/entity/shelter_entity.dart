import 'package:freezed_annotation/freezed_annotation.dart';

part 'shelter_entity.freezed.dart';
part 'shelter_entity.g.dart';

@freezed
class ShelterEntity with _$ShelterEntity {
  const factory ShelterEntity({
    required String localitate,
    required String adresa,
    required String tip,
    required double latitudine,
    required double longitudine,
    required int capacitate,
  }) = _ShelterEntity;

  factory ShelterEntity.fromJson(Map<String, dynamic> json) =>
      _$ShelterEntityFromJson(json);
}