import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelter_booking/core/core.dart';
import 'package:shelter_booking/core/functions/file_picker_service.dart';
import 'package:shelter_booking/shelters_screen/entity/shelter_entity.dart';

part 'shelters_event.dart';

part 'shelters_state.dart';

part 'shelters_bloc.freezed.dart';

class SheltersBloc extends Bloc<SheltersEvent, SheltersState> {
  SheltersBloc() : super(const SheltersState()) {
    on<_getSheltersListEvent>(_onGetSheltersList);
    on<_bookShelterEvent>(_onBookShelter);
    on<_logoutEvent>(_onLogout);
  }

  Future<void> _onGetSheltersList(
      _getSheltersListEvent event, Emitter<SheltersState> emit) async {
    emit(state.copyWith(status: SheltersStatus.loading));
    final FilePickerService filePickerService = FilePickerService();

    final sheltersList = await filePickerService.loadCsvData();
    final List<ShelterEntity> shelters = sheltersList.map(
      (e) {
        final json = {
          'localitate': e['localitate'],
          'adresa': e['adresa'],
          'tip': e['tip'],
          'latitudine': e['latitudine'] is double
              ? e['latitudine']
              : double.parse(e['latitudine'].replaceAll(',', '.')),
          'longitudine': e['longitudine'] is double
              ? e['longitudine']
              : double.parse(e['longitudine'].replaceAll(',', '.')),
          'capacitate': e['capacitate'],
        };

        return ShelterEntity.fromJson(json);
      },
    ).toList();

    if (shelters.isNotEmpty) {
      emit(state.copyWith(
        status: SheltersStatus.success,
        sheltersList: shelters,
      ));
    } else {
      emit(state.copyWith(status: SheltersStatus.failure));
    }
  }

  Future<void> _onBookShelter(
    _bookShelterEvent event,
    Emitter<SheltersState> emit,
  ) async {
    emit(state.copyWith(status: SheltersStatus.loading));
    bookShelters(event.shelter);
    updateShelterPlaces(event.shelter);
  }

  Future<void> bookShelters(ShelterEntity shelter) async {
    // Reference to the Realtime Database
    final DatabaseReference usersReference =
        FirebaseDatabase.instance.ref().child('users');
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final response =
        await usersReference.child(userId!).child('bookedShelters').get();
    if (response.value == null) {
      await usersReference.child(userId).update({
        'bookedShelters': [shelter.toJson()],
      });
    } else {
      final List<dynamic> bookedShelters = response.value as List<dynamic>;
      var newList = [...bookedShelters, shelter.toJson()];
      await usersReference.child(userId).update({
        'bookedShelters': newList,
      });
    }
  }

  Future<void> updateShelterPlaces(ShelterEntity shelter) async {
    // Reference to the Realtime Database
    final DatabaseReference sheltersReference =
        FirebaseDatabase.instance.ref().child('shelters');
    final shelters = await sheltersReference.get();
    final shelterId = castMap(shelters.value as Map<Object?, Object?>);
    shelterId.forEach((key, value) {
      final map = convertMap(value);
      map.forEach((key2, value2) {
        if (value2 == shelter.adresa) {
          sheltersReference.child(key).update({
            'capacitate': shelter.capacitate - 1,
          });
        }
      });
    });
  }

  Future<void> _onLogout(_logoutEvent event, Emitter<SheltersState> emit) async {
    emit(state.copyWith(status: SheltersStatus.loading));
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();
    prefs.setBool(Strings.isLoggedInText, false);
    emit(state.copyWith(status: SheltersStatus.loggedOut));
  }
}
