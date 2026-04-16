import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:olabisiolai_flutter_app/screens/map_screen/widget/custom_map_app_bar.dart';
import 'package:olabisiolai_flutter_app/widgets/inputs/custom_floationg_search_widget.dart';
import 'package:olabisiolai_flutter_app/screens/map_screen/widget/map_location_sheet_widget.dart';

import '../../constant/app_asserts_icons_path.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    _handleLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ===================== FAKE MAP =====================
          Container(
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                "Map Disabled",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          // ===================== APP BAR =====================
          CustomMapAppBar(
            logoPath: AppAssertsIconsPath.instance.gidiraNameLogo,
            onSearchTap: () {
              debugPrint("Search clicked");
            },
          ),

          // ===================== SEARCH =====================
          Positioned(
            top: 130,
            left: 20,
            right: 20,
            child: CustomFloatingSearchWidget(
              hintText: "Search for a business or area...",
              prefixIcon: const Icon(Icons.location_on_outlined),
              onTap: () {},
            ),
          ),

          // ===================== BOTTOM SHEET =====================
          const Align(
            alignment: Alignment.bottomCenter,
            child: MapLocationSheetWidget(),
          ),

          // ===================== LOCATION BUTTON =====================
          Positioned(
            bottom: 300,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== GET LOCATION =====================
  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint("Permission denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      debugPrint("Lat: ${position.latitude}, Lng: ${position.longitude}");
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }

  // ===================== PERMISSION =====================
  Future<void> _handleLocationPermission() async {
    await Geolocator.requestPermission();
  }
}
