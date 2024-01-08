import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shelter_booking/core/functions/file_picker_service.dart';
import 'package:shelter_booking/shelters_screen/entity/shelter_entity.dart';

part 'shelters_event.dart';

part 'shelters_state.dart';

part 'shelters_bloc.freezed.dart';

class SheltersBloc extends Bloc<SheltersEvent, SheltersState> {
  SheltersBloc() : super(const SheltersState()) {
    on<_getSheltersListEvent>(_onGetSheltersList);
  }

  Future<void> _onGetSheltersList(
      _getSheltersListEvent event, Emitter<SheltersState> emit) async {
    emit(state.copyWith(status: SheltersStatus.loading));
    final FilePickerService filePickerService = FilePickerService();

    final sheltersCvs = await filePickerService.loadCsvData();

    final sheltersList = sheltersCvs
        .map(
          (e) => filePickerService.convertToJSON(e),
        )
        .toList();
    sheltersList.removeAt(0);
    final List<ShelterEntity> shelters = sheltersList.map(
      (e) {
        List<dynamic> headerList = json.decode(e);
        return ShelterEntity.fromJson(headerList[0]);
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
}
