import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapHomePage extends StatelessWidget {
  const GoogleMapHomePage({
    super.key,
    required this.controller,
    required this.markers,
    required this.onCreated,
    required this.polygons,
    required this.zoom,
  });

  final GoogleMapController? controller;
  final Set<Marker> markers;
  final Set<Polygon> polygons;
  final Function(GoogleMapController?) onCreated;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) => onCreated(controller),
      initialCameraPosition: CameraPosition(
        target: const LatLng(-1.269160, 116.825264),
        zoom: zoom, // Adjust the zoom level as needed
      ),
      polygons: polygons,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      compassEnabled: true,
      markers: markers,
    );
  }
}
