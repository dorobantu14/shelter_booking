import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shelter_booking/core/core.dart';
import 'package:shelter_booking/shelters_screen/domain/bloc/shelters_bloc.dart';
import 'package:shelter_booking/shelters_screen/entity/shelter_entity.dart';

class SheltersScreen extends StatefulWidget {
  const SheltersScreen({super.key});

  @override
  State<SheltersScreen> createState() => _SheltersScreenState();
}

class _SheltersScreenState extends State<SheltersScreen> {
  bool filtersMenuVisible = false;
  List<String> filterOptions = ['By Sector: ', 'By Type: '];
  List<String> sectorFilters = ['1', '2', '3', '4', '5', '6'];
  Set<String> selectedSectorFilters = {};
  List<String> typeFilters = ['Public', 'Private'];
  Set<String> selectedTypeFilters = {};
  List<ShelterEntity> filteredShelters = [];

  @override
  void initState() {
    super.initState();
    context.read<SheltersBloc>().add(const SheltersEvent.getSheltersList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SheltersBloc, SheltersState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 32, left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getScreenTitle(),
                _getFiltersButton(),
                const SizedBox(height: 8),
                _getFilters(state),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 12),
                    itemCount: filteredShelters.isNotEmpty
                        ? filteredShelters.length
                        : state.sheltersList.length,
                    itemBuilder: (context, index) =>
                        _buildShelterItem(state, index),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getFiltersButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          filtersMenuVisible = !filtersMenuVisible;
        });
      },
      child: Row(
        children: [
          Icon(Icons.filter_list_outlined,
              color: AppColors.pink.withOpacity(0.6), size: 32),
          const Text(
            'Filter by your preferences',
            style: TextStyles.greySubtitleTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _getFilters(SheltersState state) {
    return Visibility(
      visible: filtersMenuVisible,
      child: Container(
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: filterOptions
              .map((e) => Row(
                    children: [
                      Text(e),
                      e == 'By Sector: '
                          ? _getSectorFilters(state)
                          : _getTypeFilters(state),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _getSectorFilters(SheltersState state) {
    return Expanded(
      child: Wrap(
        spacing: 2.0,
        children: sectorFilters.map((sector) {
          return FilterChip(
            label: Text(sector),
            selected: selectedSectorFilters.contains('Sector $sector'),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  selectedSectorFilters.add('Sector $sector');
                } else {
                  selectedSectorFilters.remove('Sector $sector');
                }
                _updateFilteredShelters(state);
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _getTypeFilters(SheltersState state) {
    return Wrap(
      spacing: 5.0,
      children: typeFilters.map((type) {
        return FilterChip(
          label: Text(type),
          selected: selectedTypeFilters
              .contains(type == 'Private' ? 'privat' : type.toLowerCase()),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedTypeFilters
                    .add(type == 'Private' ? 'privat' : type.toLowerCase());
              } else {
                selectedTypeFilters
                    .remove(type == 'Private' ? 'privat' : type.toLowerCase());
              }
              _updateFilteredShelters(state);
            });
          },
        );
      }).toList(),
    );
  }

  void _updateFilteredShelters(SheltersState state) {
    setState(() {
      if (selectedSectorFilters.isNotEmpty && selectedTypeFilters.isNotEmpty) {
        filteredShelters = state.sheltersList
            .where((shelter) =>
                selectedSectorFilters.contains(shelter.localitate) &&
                selectedTypeFilters.contains(shelter.tip))
            .toList();
      } else if (selectedSectorFilters.isNotEmpty &&
          selectedTypeFilters.isEmpty) {
        filteredShelters = state.sheltersList
            .where(
                (shelter) => selectedSectorFilters.contains(shelter.localitate))
            .toList();
      } else if (selectedSectorFilters.isEmpty &&
          selectedTypeFilters.isNotEmpty) {
        filteredShelters = state.sheltersList
            .where((shelter) => selectedTypeFilters.contains(shelter.tip))
            .toList();
      }
    });
  }

  Widget _getScreenTitle() {
    return const Text(
      'Shelters',
      style: TextStyles.boldTitleTextStyle,
    );
  }

  Widget _buildShelterItem(SheltersState state, int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              _getShelterIcon(
                  filteredShelters.isNotEmpty
                      ? filteredShelters
                      : state.sheltersList,
                  index),
              _getShelterDetails(
                  filteredShelters.isNotEmpty
                      ? filteredShelters
                      : state.sheltersList,
                  index),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Divider(
            color: AppColors.lightGrey.withOpacity(0.2),
          ),
        )
      ],
    );
  }

  Widget _getShelterIcon(List<ShelterEntity> sheltersList, int index) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Center(
          child: sheltersList[index].tip == 'privat'
              ? const Icon(Icons.public_off_outlined)
              : const Icon(Icons.public)),
    );
  }

  Widget _getShelterDetails(List<ShelterEntity> sheltersList, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getShelterAddress(sheltersList[index]),
            Text(
              'Available places: ${sheltersList[index].capacitate}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getShelterAddress(ShelterEntity shelter) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on_outlined,
          color: AppColors.lightGrey.withOpacity(0.5),
          size: 20,
        ),
        Expanded(
          child: Text(
            '${shelter.localitate}, ${shelter.adresa}',
          ),
        ),
      ],
    );
  }
}
