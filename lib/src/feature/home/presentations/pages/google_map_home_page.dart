import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapHomePage extends StatefulWidget {
  const GoogleMapHomePage(
      {super.key,
      required this.controller,
      required this.markers,
      required this.onCreated,
      required this.polygons});

  final GoogleMapController? controller;
  final Set<Marker> markers;
  final Set<Polygon> polygons;
  final Function(GoogleMapController?) onCreated;

  @override
  State<GoogleMapHomePage> createState() => _GoogleMapHomePageState();
}

class _GoogleMapHomePageState extends State<GoogleMapHomePage> {
  // Example coordinates for Mauritius

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) => widget.onCreated(controller),
      initialCameraPosition: const CameraPosition(
        target: LatLng(-1.269160, 116.825264),
        zoom: 13.0, // Adjust the zoom level as needed
      ),
      polygons: widget.polygons,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      compassEnabled: true,
      markers: widget.markers,
    );
  }
}
