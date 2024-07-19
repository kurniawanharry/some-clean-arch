import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class MapScreenV2 extends StatefulWidget {
  const MapScreenV2({super.key});

  @override
  _MapScreenV2State createState() => _MapScreenV2State();
}

class _MapScreenV2State extends State<MapScreenV2> {
  late MapShapeSource _mapSource;

  @override
  void initState() {
    _mapSource = const MapShapeSource.asset(
      'assets/indonesia.json', // Path to your Indonesia shapefile
      shapeDataField: 'NAME_1', // Adjust this based on your shapefile's data field
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indonesia Map'),
      ),
      body: SfMaps(
        layers: [
          MapShapeLayer(
            source: _mapSource,
            showDataLabels: true,
            dataLabelSettings: const MapDataLabelSettings(
              textStyle: TextStyle(color: Colors.black),
            ),
            strokeColor: Colors.white,
            strokeWidth: 0.5,
          ),
        ],
      ),
    );
  }
}
