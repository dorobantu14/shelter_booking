part of 'shelters_bloc.dart';

@freezed
class SheltersEvent with _$SheltersEvent {
  const factory SheltersEvent.getSheltersList() = _getSheltersListEvent;
  const factory SheltersEvent.bookShelter({
    required ShelterEntity shelter,
  }) = _bookShelterEvent;
}
