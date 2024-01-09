import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:info_popup/info_popup.dart';
import 'package:latlong2/latlong.dart' as coordinates;
import 'package:shelter_booking/core/core.dart';
import 'package:shelter_booking/shelters_screen/entity/shelter_entity.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final List<ShelterEntity> sheltersList;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.sheltersList,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _getActionButtons(),
      appBar: AppBar(
        elevation: 5,
        title: Text(
          'Shelter Map',
          style: TextStyles.boldTitleTextStyle.copyWith(fontSize: 36),
        ),
        leading: _getBackButton(context),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: coordinates.LatLng(widget.latitude, widget.longitude),
          initialZoom: 18.0,
        ),
        children: [
          _getMapLayer(),
          _getSheltersLayer(),
        ],
      ),
    );
  }

  Column _getActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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
      child: const Icon(Icons.remove),
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
      child: const Icon(Icons.add),
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
      child: const Icon(
        Icons.location_on_outlined,
        color: AppColors.blue,
        size: 40,
      ),
    );
  }
}
