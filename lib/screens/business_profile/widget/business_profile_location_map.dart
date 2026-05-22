import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/app_colors.dart';
import '../../../utils/gap.dart';
import '../../../widgets/texts/app_text.dart';

class BusinessProfileLocationMap extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final String? locationName;

  const BusinessProfileLocationMap({
    super.key,
    this.latitude,
    this.longitude,
    this.locationName,
  });

  String _getStaticMapUrl() {
    final String apiKey = "AIzaSyDkW397ZVPp9dxR5hIUp-u5dvEhefNn52k";
    if (latitude != null && longitude != null) {
      return "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=14&size=600x300&key=$apiKey";
    } else if (locationName != null && locationName!.isNotEmpty) {
      return "https://maps.googleapis.com/maps/api/staticmap?center=${Uri.encodeComponent(locationName!)}&zoom=14&size=600x300&key=$apiKey";
    }
    return "https://maps.googleapis.com/maps/api/staticmap?center=Lagos,Nigeria&zoom=14&size=600x300&key=$apiKey";
  }

  void _openDetailedMap() async {
    Uri uri;
    if (latitude != null && longitude != null) {
      uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
    } else if (locationName != null && locationName!.isNotEmpty) {
      uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(locationName!)}");
    } else {
      uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=Lagos,Nigeria");
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) { 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: "Service Area",
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
        AppText(
          text: locationName ?? "Location not specified",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.instance.buttonColor,
        ),
        Gap(height: 16),
        GestureDetector(
          onTap: _openDetailedMap,
          child: Stack(
            children: [
              // Map Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  _getStaticMapUrl(),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Icon(Icons.map_outlined, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              // Center Marker (perfect center alignment)
              const Positioned.fill(
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 25,
                    child: Icon(Icons.location_on, color: Colors.white, size: 30),
                  ),
                ),
              ),
  
              // Bottom Button Overlay
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: AppText(
                      text: "Click to expand detailed map",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
