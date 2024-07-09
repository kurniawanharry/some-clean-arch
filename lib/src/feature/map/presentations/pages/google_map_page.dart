import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'dart:ui' as ui;

import 'package:location/location.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/core/util/constants/constants.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  LocationData? _currentLocation;
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  double lat = 0.0;
  double lng = 0.0;
  geo.Placemark? currentPlacemark;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    if (_controller.isCompleted) {
      _controller.future.then((controller) {
        controller.dispose();
      });
    }
    super.dispose();
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
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 1.0,
              ),
              zoomGesturesEnabled: false,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              trafficEnabled: false,
              markers: _markers,
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
                            Icons.refresh,
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
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.secondary,
                        ),
                      ),
                      child: Text(
                        '${currentPlacemark?.street},${currentPlacemark?.subLocality}, ${currentPlacemark?.locality}, ${currentPlacemark?.subAdministrativeArea}, ${currentPlacemark?.administrativeArea}',
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
                              'placemark': currentPlacemark,
                              'lat': lat,
                              'lng': lng,
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

  Future _getCurrentLocation() async {
    Location location = Location();

    try {
      bool serviceEnabled = await location.serviceEnabled();

      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _currentLocation = await location.getLocation();

      lat = _currentLocation?.latitude ?? 0.0;
      lng = _currentLocation?.longitude ?? 0.0;

      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        geo.Placemark placemark = placemarks[0];
        currentPlacemark = placemark;

        var data = await rootBundle.load('${imagePath}logo.png');
        var image = data.buffer.asUint8List();
        BitmapDescriptor userPicture = await getMarkerIcon(
          image,
          const Size(150.0, 150.0),
        );

        // Add a marker with the detailed address

        setState(() {
          _markers.add(
            Marker(
              markerId: const MarkerId("user_location"),
              position: LatLng(lat, lng),
              icon: userPicture,
              anchor: const Offset(0.5, 0.5),
            ),
          );
        });

        if (_controller.isCompleted) {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(lat, lng), 18.0),
          );
        }
      }
    } catch (e) {
      // Fluttertoast.showToast(
      //   msg: e.toString(),
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.grey.shade400,
      //   textColor: Colors.black,
      //   fontSize: 16.0,
      // );
    }
  }
}

Future<ui.Image> getImageFromPath(Uint8List? image) async {
  final Completer<ui.Image> completer = Completer();

  ui.decodeImageFromList(image!, (ui.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}

Future<BitmapDescriptor> getMarkerIcon(Uint8List image8list, Size size) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final Radius radius = Radius.circular(size.width / 2);

  final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
  const double shadowWidth = 15.0;

  final Paint borderPaint = Paint()..color = Colors.white;
  const double borderWidth = 3.0;

  const double imageOffset = shadowWidth + borderWidth;

  // Add shadow circle
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      shadowPaint);

  // Add border circle
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(shadowWidth, shadowWidth, size.width - (shadowWidth * 2),
            size.height - (shadowWidth * 2)),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      borderPaint);

  // Oval for the image
  Rect oval = Rect.fromLTWH(
      imageOffset, imageOffset, size.width - (imageOffset * 2), size.height - (imageOffset * 2));

  // Add path for oval image
  canvas.clipPath(Path()..addOval(oval));

  // Add image
  ui.Image image =
      await getImageFromPath(image8list); // Alternatively use your own method to get the image
  paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

  // Convert canvas to image
  final ui.Image markerAsImage =
      await pictureRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt());

  // Convert image to bytes
  final ByteData? byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List uint8List = byteData!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(uint8List);
}
