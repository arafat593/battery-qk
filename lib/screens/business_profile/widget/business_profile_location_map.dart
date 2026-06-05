import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessProfileLocationMap extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? locationName;

  const BusinessProfileLocationMap({
    super.key,
    this.latitude,
    this.longitude,
    this.locationName,
  });

  @override
  State<BusinessProfileLocationMap> createState() => _BusinessProfileLocationMapState();
}

class _BusinessProfileLocationMapState extends State<BusinessProfileLocationMap> {
  bool _useFallback = false;

  String _getStaticMapUrl() {
    final String apiKey = "AIzaSyDkW397ZVPp9dxR5hIUp-u5dvEhefNn52k";
    if (widget.latitude != null && widget.longitude != null) {
      return "https://maps.googleapis.com/maps/api/staticmap?center=${widget.latitude},${widget.longitude}&zoom=14&size=600x300&key=$apiKey";
    } else if (widget.locationName != null && widget.locationName!.isNotEmpty) {
      return "https://maps.googleapis.com/maps/api/staticmap?center=${Uri.encodeComponent(widget.locationName!)}&zoom=14&size=600x300&key=$apiKey";
    }
    return "https://maps.googleapis.com/maps/api/staticmap?center=Lagos,Nigeria&zoom=14&size=600x300&key=$apiKey";
  }

  String _getFallbackMapUrl() {
    final double lat = widget.latitude ?? 6.5244;
    final double lng = widget.longitude ?? 3.3792;
    return "https://static-maps.yandex.ru/1.x/?ll=$lng,$lat&z=14&size=600,300&l=map&pt=$lng,$lat,pm2rdm";
  }

  void _openDetailedMap() async {
    Uri uri;
    if (widget.latitude != null && widget.longitude != null) {
      uri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}",
      );
    } else if (widget.locationName != null && widget.locationName!.isNotEmpty) {
      uri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(widget.locationName!)}",
      );
    } else {
      uri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=Lagos,Nigeria",
      );
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
          text: widget.locationName ?? "Location not specified",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.instance.buttonColor,
        ),
        const Gap(height: 16),
        GestureDetector(
          onTap: _openDetailedMap,
          child: Stack(
            children: [
              // Map Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  _useFallback ? _getFallbackMapUrl() : _getStaticMapUrl(),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    if (!_useFallback) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _useFallback = true;
                          });
                        }
                      });
                      return Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.map_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              // Center Marker (perfect center alignment)
              const Positioned.fill(
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 25,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 30,
                    ),
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
