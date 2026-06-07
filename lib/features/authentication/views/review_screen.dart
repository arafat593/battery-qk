import 'package:flutter/material.dart';
import '../../../common/widgets/listings_details_custom/custom_reviews.dart';
import '../models/review_model.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key, required this.reviews});

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'All Reviews',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 30),
              if (reviews.isEmpty) const Text('No Reviews Available yet'),
              Expanded(
                child: ListView.separated(
                  itemCount: reviews.length,
                  reverse: false,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return CustomReviews(
                      starCount: reviews[index].rating,
                      name: reviews[index].user,
                      designation: reviews[index].comment,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
