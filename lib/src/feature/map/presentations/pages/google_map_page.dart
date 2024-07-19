import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:some_app/src/core/styles/app_colors.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = LatLng(-1.269160, 116.825264);
  LatLng _currentPosition = _center;
  String _currentAddress = '';
  Timer? _debounce;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    _loadGeoJson();
    _checkPermissions();
  }

  @override
  void dispose() {
    if (_controller.isCompleted) {
      _controller.future.then((controller) {
        controller.dispose();
      });
    }
    _debounce?.cancel();
    super.dispose();
  }

  Set<Polygon> _polygons = {};

  void _loadGeoJson() async {
    String data = await DefaultAssetBundle.of(context).loadString('assets/balikpapan.json');
    Map<String, dynamic> geoJson = jsonDecode(data);

    Set<Polygon> polygons = {};
    for (var coordinates in geoJson['coordinates']) {
      for (var polygon in coordinates) {
        List<LatLng> polygonCoords = [];
        for (var coord in polygon) {
          polygonCoords.add(
            LatLng(
              double.parse(coord[1].toString()),
              double.parse(
                coord[0].toString(),
              ),
            ),
          );
        }
        polygons.add(
          Polygon(
            polygonId: PolygonId(polygonCoords.toString()),
            points: polygonCoords,
            strokeColor: Colors.blue,
            strokeWidth: 3,
            fillColor: Colors.blue.withOpacity(0.2),
          ),
        );
      }
    }

    setState(() {
      _polygons = polygons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IgnorePointer(
            ignoring: !_controller.isCompleted,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 1.0,
              ),
              onCameraMove: _onCameraMove,
              zoomControlsEnabled: false,
              polygons: _polygons,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: const Offset(2, -10),
              child: const Icon(
                Icons.location_on,
                size: 45,
                color: AppColors.red,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      IconButton(
                        onPressed: context.pop,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.secondary,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: _getCurrentLocation,
                          icon: const Icon(
                            Icons.my_location_rounded,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_controller.isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.secondary,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        _currentAddress,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontSize: 14,
                            ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: _controller.isCompleted
                        ? () => context.pop({
                              'address': _currentAddress,
                              'lat': _currentPosition.latitude,
                              'lng': _currentPosition.longitude,
                            })
                        : null,
                    child: _controller.isCompleted
                        ? const Text('Pilih')
                        : const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _currentPosition = LatLng(position.latitude, position.longitude);
    _getAddressFromLatLng(_currentPosition);
    _controller.future
        .then((value) => value.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 18.0)));
  }

  void _onCameraMove(CameraPosition position) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _currentPosition = position.target;
      _getAddressFromLatLng(_currentPosition);
    });
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
      });
      // ignore: empty_catches
    } catch (e) {}
  }
}
