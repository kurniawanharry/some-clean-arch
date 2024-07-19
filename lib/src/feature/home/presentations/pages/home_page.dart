import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:some_app/src/core/styles/app_colors.dart';
import 'package:some_app/src/feature/authentication/presentations/cubit/auth_cubit.dart';
import 'package:some_app/src/feature/home/presentations/cubit/home_cubit.dart';
import 'package:some_app/src/feature/home/presentations/pages/google_map_home_page.dart';
import 'dart:ui' as ui;
import 'package:xml/xml.dart' as xml;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.type = 200,
  });

  final int? type;

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
  final Set<Polygon> _polygons = {};

  // void _setPolygons() {
  //   final List<LatLng> polygonCoords = [
  //     const LatLng(-1.1659, 116.7727), // Northwest corner
  //     const LatLng(-1.1201, 116.8453), // North
  //     const LatLng(-1.1572, 116.9150), // Northeast
  //     const LatLng(-1.2380, 116.9727), // East
  //     const LatLng(-1.3273, 116.9290), // Southeast
  //     const LatLng(-1.3652, 116.8447), // South
  //     const LatLng(-1.3245, 116.7688), // Southwest
  //     const LatLng(-1.2355, 116.7210), // West
  //     const LatLng(-1.1659, 116.7727), // Back to Northwest corner
  //   ];

  //   _polygons.add(
  //     Polygon(
  //       polygonId: const PolygonId('balikpapan'),
  //       points: polygonCoords,
  //       strokeColor: Colors.blue,
  //       strokeWidth: 3,
  //       fillColor: Colors.blue.withOpacity(0.2),
  //     ),
  //   );
  // }

  @override
  void initState() {
    _cubit = BlocProvider.of<HomeCubit>(context);
    _cubit.fetchUsers();

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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
                final Uint8List markerIcon = await _createCustomMarkerBitmap(
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
          onPressed: () => context.read<AuthCubit>().logout(),
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

Future<Uint8List> _createCustomMarkerBitmap(String text, String imagePath, bool isVerif) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = isVerif ? Colors.white : Colors.pink.shade200;

  const double width = 360; // Increase the width to accommodate text and image in a row
  const double height = 90; // Adjust height as needed
  const double borderRadius = 12.0;

  final RRect roundedRect =
      RRect.fromLTRBR(0.0, 0.0, width, height, const Radius.circular(borderRadius));
  canvas.drawRRect(roundedRect, paint);

  // Draw the triangle at the bottom
  final Paint trianglePaint = Paint()..color = isVerif ? Colors.white : Colors.pink.shade200;
  final Path path = Path();
  path.moveTo(width / 2 - 10, height);
  path.lineTo(width / 2 + 10, height);
  path.lineTo(width / 2, height + 10);
  path.close();
  canvas.drawPath(path, trianglePaint);

  // final ByteData data = await rootBundle.load(imagePath);
  // final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
  //     targetWidth: 80); // Adjust image size
  // final ui.FrameInfo fi = await codec.getNextFrame();

  // Download and draw the image from the URL
  final Dio dio = Dio();
  final Response<List<int>> response = await dio.get<List<int>>(
    imagePath,
    options: Options(responseType: ResponseType.bytes),
  );
  final Uint8List bytes = Uint8List.fromList(response.data!);
  final ui.Codec codec = await ui.instantiateImageCodec(bytes, targetWidth: 80);
  final ui.FrameInfo fi = await codec.getNextFrame();

  final ui.Image image = fi.image;
  canvas.drawImage(image, const Offset(10, 10), Paint()); // Position image to the left

  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(color: Colors.black, fontSize: 20),
    ),
    textAlign: TextAlign.left,
    textDirection: TextDirection.ltr,
    maxLines: 5,
    ellipsis: '...',
  );

  textPainter.layout(minWidth: 0, maxWidth: width - 100); // Adjust width for text
  textPainter.paint(canvas, const Offset(100, 10)); // Position text to the right of the image

  final ui.Image markerAsImage =
      await pictureRecorder.endRecording().toImage(width.toInt(), (height + 10).toInt());
  final ByteData? byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
