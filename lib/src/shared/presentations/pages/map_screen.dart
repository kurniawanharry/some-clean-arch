import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final BitmapDescriptor bitMap;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.bitMap,
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
        markers: <Marker>{
          Marker(
            markerId: const MarkerId('location_marker'),
            position: LatLng(latitude, longitude),
            icon: bitMap,
            anchor: const Offset(0.5, 0.5),
          ),
        },
      ),
    );
  }
}
