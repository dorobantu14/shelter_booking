import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:info_popup/info_popup.dart';
import 'package:latlong2/latlong.dart' as coordinates;
import 'package:shelter_booking/core/core.dart';
import 'package:shelter_booking/core/functions/google_directions.dart';
import 'package:shelter_booking/core/widgets/location_search.dart';
import 'package:shelter_booking/shelters_screen/domain/bloc/shelters_bloc.dart';
import 'package:shelter_booking/shelters_screen/entity/shelter_entity.dart';

class MapScreen extends StatefulWidget {
  final ShelterEntity selectedShelter;
  final BuildContext context;

  const MapScreen({
    super.key,
    required this.selectedShelter,
    required this.context,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  Position? _currentUserPosition;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  PolylineLayer? _directionsLayer;
  MarkerLayer searchLocationLayer = const MarkerLayer(markers: []);
  final TextEditingController controller = TextEditingController();
  Marker endRoutePoint = const Marker(
    point: coordinates.LatLng(45.522054, -122.690176),
    child: Icon(
      Icons.circle,
      color: Colors.red,
      size: 40,
    ),
  );

  Marker startRoutePoint = const Marker(
    point: coordinates.LatLng(45.522054, -122.690176),
    child: Icon(
      Icons.circle,
      color: Colors.red,
      size: 40,
    ),
  );
  bool showingUpRoute = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    controller.addListener(refreshCallback);
  }

  void refreshCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      _getCurrentLocation();
      if (_currentUserPosition != null) {
        updateLocation(
          _currentUserPosition!.latitude,
          _currentUserPosition!.longitude,
        );
      }
    });

    return Scaffold(
      floatingActionButton: _getActionButtons(),
      appBar: AppBar(
        elevation: 5,
        title: Text(
          'Shelter Map',
          style: TextStyles.boldTitleTextStyle.copyWith(fontSize: 36),
        ),
        leading: _getBackButton(context),
        actions: [
          _getBookShelterButton(),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: coordinates.LatLng(
                widget.selectedShelter.latitudine,
                widget.selectedShelter.longitudine,
              ),
              initialZoom: 16.0,
            ),
            children: [
              _getMapLayer(),
              if (showingUpRoute == false) _getSheltersLayer(),
              if (_currentUserPosition != null && showingUpRoute == false)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: coordinates.LatLng(_currentUserPosition!.latitude,
                          _currentUserPosition!.longitude),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.pink,
                      ),
                    )
                  ],
                ),
              if (_directionsLayer != null && showingUpRoute == true)
                _directionsLayer!,
              if (showingUpRoute) MarkerLayer(markers: [startRoutePoint]),
              if (showingUpRoute) MarkerLayer(markers: [endRoutePoint]),
            ],
          ),
          getSearchField(context),
        ],
      ),
    );
  }

  Widget getSearchField(BuildContext context) {
    return Positioned.fill(
      top: MediaQuery.of(context).size.height * 0.02,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey,
                    blurRadius: 30,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: LocationSearch(
                borderRadius: 5,
                borderColor: AppColors.white,
                hint: 'Hi, where do you want to go?',
                controller: controller,
                fillColor: AppColors.white,
                prefixIcon: const Icon(Icons.search_outlined),
                hasShadow: true,
                onTap: (location) async {
                  final coordinates.LatLng searchedPlaceCoordinates =
                      await getPlaceCoordinates(location);
                  mapController.move(searchedPlaceCoordinates, 15.0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<coordinates.LatLng> getPlaceCoordinates(String placeName) async {
    try {
      // Use the geocoding API to get coordinates
      List<Location> locations = await locationFromAddress(placeName);

      // Access the first location (you can iterate over the list if there are multiple matches)
      Location location = locations.first;

      return coordinates.LatLng(location.latitude, location.longitude);
    } catch (e) {
      return const coordinates.LatLng(0, 0);
    }
  }

  Widget _getBookShelterButton() {
    return TextButton(
        onPressed: () {
          context.read<SheltersBloc>().add(
                SheltersEvent.bookShelter(shelter: widget.selectedShelter),
              );
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Shelter booked'),
                    content: const Text(
                        'You have successfully booked this shelter. Go to your profile to see the details.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      )
                    ],
                  ));
          widget.context
              .read<SheltersBloc>()
              .add(const SheltersEvent.getSheltersList());
        },
        child: Text(
          'Book',
          style: TextStyles.blackButtonTextStyle.copyWith(
            fontSize: 24,
            color: AppColors.grey.withOpacity(0.6),
          ),
        ));
  }

  void displayDirections() async {
    const origin = coordinates.LatLng(
        44.4383, 26.0514); // Replace with your actual origin coordinates
    final destination = coordinates.LatLng(
      widget.selectedShelter.latitudine,
      widget.selectedShelter.longitudine,
    ); // Replace with your actual destination coordinates

    final directions = await getDirections(origin, destination);

    setState(() {
      mapController.move(origin, 10.0);
      _directionsLayer = PolylineLayer(
        polylines: [
          Polyline(
            points: [origin, ...directions, destination],
            color: AppColors.blue,
            strokeWidth: 4.0,
          ),
        ],
      );
      startRoutePoint = const Marker(
        point: origin,
        child: Icon(
          Icons.person_2_outlined,
          color: AppColors.pink,
          size: 40,
        ),
      );
      endRoutePoint = Marker(
        point: destination,
        child: const Icon(
          Icons.location_on_outlined,
          color: AppColors.pink,
          size: 40,
        ),
      );
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission =
          await _geolocatorPlatform.checkPermission();
      if (await _geolocatorPlatform.isLocationServiceEnabled() &&
          (permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse)) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          if (Platform.isIOS) {
            _currentUserPosition = Position(
              latitude: 44.4383,
              longitude: 26.0514,
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              heading: 0,
              speed: 0,
              speedAccuracy: 0,
              altitudeAccuracy: 0,
              headingAccuracy: 0,
            );
          } else {
            _currentUserPosition = position;
          }
        });
      } else {
        await _geolocatorPlatform.requestPermission();
        await _getCurrentLocation();
      }
    } catch (e) {}
  }

  Column _getActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _getGoShelterButton(),
        const SizedBox(height: 16), // Adjust the spacing between buttons
        _getFindMeButton(),
        const SizedBox(height: 16), // Adjust the spacing between buttons
        _getZoomInButton(),
        const SizedBox(height: 16), // Adjust the spacing between buttons
        _getZoomOutButton(),
      ],
    );
  }

  FloatingActionButton _getZoomOutButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.lightGrey.withOpacity(0.7),
      onPressed: () {
        mapController.move(
            mapController.camera.center, mapController.camera.zoom - 1);
      },
      tooltip: 'Second Button',
      child: const Icon(
        Icons.remove,
        color: AppColors.white,
      ),
    );
  }

  FloatingActionButton _getGoShelterButton() {
    return FloatingActionButton(
        backgroundColor: AppColors.lightGrey.withOpacity(0.7),
        onPressed: () {
          if (showingUpRoute == false) displayDirections();
          setState(() {
            showingUpRoute = !showingUpRoute;
          });
        },
        tooltip: 'Second Button',
        child: const Icon(
          Icons.navigation_outlined,
          color: AppColors.white,
        ));
  }

  FloatingActionButton _getFindMeButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.lightGrey.withOpacity(0.7),
      onPressed: () {
        if (_currentUserPosition != null) {
          mapController.move(
            coordinates.LatLng(
              _currentUserPosition!.latitude,
              _currentUserPosition!.longitude,
            ),
            mapController.camera.zoom,
          );
        }
      },
      tooltip: 'Second Button',
      child: const Text(
        'FindMe',
        style: TextStyle(color: AppColors.white),
      ),
    );
  }

  FloatingActionButton _getZoomInButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.lightGrey.withOpacity(0.7),
      onPressed: () {
        mapController.move(
            mapController.camera.center, mapController.camera.zoom + 1);
      },
      tooltip: 'First Button',
      child: const Icon(
        Icons.add,
        color: AppColors.white,
      ),
    );
  }

  IconButton _getBackButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: AppColors.grey.withOpacity(0.6),
        size: 32,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  TileLayer _getMapLayer() {
    return TileLayer(
      urlTemplate:
          'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}',
      subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
    );
  }

  FeatureLayer _getSheltersLayer() {
    return FeatureLayer(FeatureLayerOptions(
      "https://services6.arcgis.com/Jg1eCiY8EyQLf5fb/arcgis/rest/services/adaposturi/FeatureServer/0",
      "point",
      render: (dynamic attributes) {
        // You can render by attribute
        return PointOptions(
          width: 40.0,
          height: 40.0,
          builder: _getShelterDetails(attributes),
        );
      },
      onTap: (attributes, coordinates.LatLng location) {},
    ));
  }

  InfoPopupWidget _getShelterDetails(attributes) {
    return InfoPopupWidget(
      contentTitle: 'Shelter from: ${attributes['Localitate']}\n '
          'Address: ${attributes['Adresa']}\n '
          'Type: ${attributes['Tip']}\n '
          'Total capacity: ${attributes['Capacitatea']}',
      child: Icon(
        Icons.location_on_outlined,
        color: attributes['Adresa'] == widget.selectedShelter.adresa
            ? AppColors.pink
            : AppColors.blue,
        size: attributes['Adresa'] == widget.selectedShelter.adresa ? 50 : 40,
      ),
    );
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference usersReference =
        FirebaseDatabase.instance.ref().child('users');
    await usersReference.child(userId).update({
      'latitude': latitude,
      'longitude': longitude,
    });
  }
}
