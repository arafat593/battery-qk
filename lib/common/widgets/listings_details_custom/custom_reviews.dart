import 'package:flutter/material.dart';

import '../../styles/styles.dart';

class CustomReviews extends StatelessWidget {
  final String name;
  final String designation;
  final int starCount;

  const CustomReviews({
    super.key,
    required this.starCount,
    required this.name,
    required this.designation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: CustomSectionHeaderText(name)),
              Row(
                children: List.generate(starCount, (index) {
                  return const Icon(Icons.star, color: Colors.amber, size: 16);
                }),
              ),
            ],
          ),
          Text(designation, style: TextStyle(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
