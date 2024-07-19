import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final Marker markers;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.markers,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 18.0,
        ),
        markers: <Marker>{markers},
      ),
    );
  }
}
