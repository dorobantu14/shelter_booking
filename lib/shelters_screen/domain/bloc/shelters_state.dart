part of 'shelters_bloc.dart';

enum SheltersStatus {
  initial,
  loading,
  success,
  failure,
  loggedOut,
}

@freezed
class SheltersState with _$SheltersState {
  const factory SheltersState({
    @Default(SheltersStatus.initial) status,
    @Default([]) List<ShelterEntity> sheltersList,
    @Default([]) List<ShelterEntity> bookedSheltersList,
  }) = _SheltersState;
}
