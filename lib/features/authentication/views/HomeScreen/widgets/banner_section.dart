import 'package:flutter/material.dart';

import '../../../../../util/images_path.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(68, 145, 145, 145).withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(AppImages.bannerImages),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
