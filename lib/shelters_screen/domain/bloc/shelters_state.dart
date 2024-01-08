part of 'shelters_bloc.dart';

enum SheltersStatus {
  initial,
  loading,
  success,
  failure,
}

@freezed
class SheltersState with _$SheltersState {
  const factory SheltersState({
    @Default(SheltersStatus.initial) status,
    @Default([]) List<ShelterEntity> sheltersList,
  }) = _SheltersState;
}
