import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/core/util/injections.dart';
import 'package:some_app/src/feature/authentication/data/data_sources/local/auth_shared_pref.dart';
import 'package:some_app/src/feature/home/presentations/cubit/home_cubit.dart';
import 'package:some_app/src/feature/home/presentations/pages/google_map_home_page.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeCubit _cubit;

  bool isAdmin = false;

  String selectedGender = 'Semua';
  String selectedValue = 'Semua';

  GoogleMapController? _controller;

  final Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  double _currentZoom = 12;

  _loadGeoJson() async {
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
  void initState() {
    _cubit = BlocProvider.of<HomeCubit>(context);
    isAdmin = getIt<AuthSharedPrefs>().isAdmin();
    _cubit.fetchUsers(isAdmin);
    _loadGeoJson();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _zoomIn() {
    _currentZoom += 1;
    _controller?.moveCamera(CameraUpdate.zoomTo(_currentZoom));
  }

  void _zoomOut() {
    _currentZoom -= 1;
    _controller?.moveCamera(CameraUpdate.zoomTo(_currentZoom));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.secondary,
                AppColors.main,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        BlocListener<HomeCubit, HomeState>(
          bloc: _cubit,
          listener: (context, state) async {
            if (state is HomeUsersSuccess) {
              for (var data in state.users) {
                final Uint8List markerIcon = await createCustomMarkerBitmap(
                  'NIK: ${data.nik}\nNama: ${data.name}\nDisabilitas: ${data.disability}\n',
                  // "assets/images/clover_tree.png",
                  "https://fastcdn.hoyoverse.com/content-v2/hk4e/113484/1a0e331a984e482f84433eac47cd5e3b_3721947678899810120.jpg",
                  data.isVerified ?? false,
                );
                var marker = Marker(
                  markerId: MarkerId('${data.nik}'),
                  position: LatLng(
                      double.parse(data.latitude ?? '0'), double.parse(data.longitude ?? '0')),
                  infoWindow: InfoWindow(title: '${data.address}'),
                  draggable: false,
                  // ignore: deprecated_member_use
                  icon: BitmapDescriptor.fromBytes(markerIcon),
                );
                setState(() => _markers.add(marker));
              }
            }
          },
          child: BlocBuilder<HomeCubit, HomeState>(
            bloc: _cubit,
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                  ),
                );
              } else {
                return Stack(
                  children: [
                    GoogleMapHomePage(
                      controller: _controller,
                      markers: _markers,
                      onCreated: (p0) => _onMapCreated(p0!),
                      polygons: _polygons,
                      zoom: _currentZoom,
                    ),
                    Positioned(
                      top: 20,
                      right: 10,
                      left: 10,
                      child: SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              decoration: BoxDecoration(
                                color: AppColors.main,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Legend',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.pink.shade200,
                                          border: Border.all(
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Belum Diverifikasi',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontSize: 14,
                                            ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          border: Border.all(
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Sudah Diverifikasi',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontSize: 14,
                                            ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }
}

Future showExitDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Apakah kamu yakin ingin keluar?'),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Tidak'),
        ),
        TextButton(
          onPressed: () async {
            await getIt<AuthSharedPrefs>().removeToken();
            // ignore: use_build_context_synchronously
            context.go('/');
          },
          child: const Text('Iya'),
        ),
      ],
    ),
  );
}

String disabilityType(String name) {
  switch (name) {
    case 'visual':
      return 'Disabilitas Netra';
    case 'hearing':
      return 'Disabilitas Rungu';
    case 'physical':
      return 'Disabilitas Fisik';
    case 'mental':
      return 'Disabilitas Mental';
    case 'physical_and_mental':
      return 'Disabilitas Fisik dan Mental';
    case 'other':
      return 'Disabilitas Lainnya';
    default:
      return 'Disabilitas Netra';
  }
}

Future<Uint8List> createCustomMarkerBitmap(String text, String imagePath, bool isVerif) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = isVerif ? Colors.white : Colors.pink.shade200;

  // Increased width and height
  const double width = 400; // Increased width
  const double height = 120; // Increased height
  const double borderRadius = 16.0; // Increased border radius

  // Draw the rounded rectangle for the image and text
  final RRect roundedRect =
      RRect.fromLTRBR(0.0, 0.0, width, height, const Radius.circular(borderRadius));
  canvas.drawRRect(roundedRect, paint);

  // Draw the triangle at the bottom
  final Paint trianglePaint = Paint()..color = isVerif ? Colors.white : Colors.pink.shade200;
  final Path path = Path();
  path.moveTo(width / 2 - 15, height);
  path.lineTo(width / 2 + 15, height);
  path.lineTo(width / 2, height + 15);
  path.close();
  canvas.drawPath(path, trianglePaint);

  // Download and draw the image from the URL using Dio
  final Dio dio = Dio();
  final Response<List<int>> response = await dio.get<List<int>>(
    imagePath,
    options: Options(responseType: ResponseType.bytes),
  );
  final Uint8List bytes = Uint8List.fromList(response.data!);
  final ui.Codec codec =
      await ui.instantiateImageCodec(bytes, targetWidth: 100); // Adjust image size
  final ui.FrameInfo fi = await codec.getNextFrame();

  final ui.Image image = fi.image;
  // Center image vertically
  final double imageTopMargin = (height - image.height) / 2;
  canvas.drawImage(image, Offset(20, imageTopMargin), Paint()); // Position image to the left

  // Draw the text
  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(color: Colors.black, fontSize: 24), // Increased font size
    ),
    textAlign: TextAlign.left,
    textDirection: TextDirection.ltr,
    maxLines: 4,
    ellipsis: '...',
  );

  textPainter.layout(minWidth: 0, maxWidth: width - 140); // Adjust width for text
  // Center text vertically
  final double textTopMargin = (height - textPainter.height) / 2;
  textPainter.paint(canvas, Offset(140, textTopMargin)); // Position text to the right of the image

  final ui.Image markerAsImage =
      await pictureRecorder.endRecording().toImage(width.toInt(), (height + 15).toInt());
  final ByteData? byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
