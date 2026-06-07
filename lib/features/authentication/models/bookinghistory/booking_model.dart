import 'package:batteryqk_web_app/features/authentication/models/bookinghistory/review_model.dart';
import 'package:batteryqk_web_app/features/authentication/models/bookinghistory/reward_model.dart';

import 'listing_model.dart';

class BookingModel {
  final int id;
  final int? userId;
  final int? listingId;
  final DateTime? bookingDate;
  final String? bookingHours;
  final String? additionalNote;
  final String? ageGroup;
  final int? numberOfPersons;
  final String? paymentMethod;
  final String? status;
  final int? reviewId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ListingModel? listing;
  final ReviewModel? review;
  final RewardModel? reward;
  final double? ratings;
  final String reviewStatus;

  BookingModel({
    required this.id,
    required this.reviewStatus,
    this.userId,
    this.listingId,
    this.bookingDate,
    this.bookingHours,
    this.additionalNote,
    this.ageGroup,
    this.numberOfPersons,
    this.paymentMethod,
    this.status,
    this.reviewId,
    this.createdAt,
    this.updatedAt,
    this.listing,
    this.review,
    this.reward,
    this.ratings,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      userId: json['userId'],
      listingId: json['listingId'],
      bookingDate:
          json['bookingDate'] != null
              ? DateTime.tryParse(json['bookingDate'])
              : null,
      bookingHours: json['booking_hours'],
      additionalNote: json['additionalNote'] ?? 'No additional note added',
      ageGroup: json['ageGroup'],
      numberOfPersons: json['numberOfPersons'],
      paymentMethod: json['paymentMethod'],
      status: json['status'] ?? 'PENDING',
      reviewId: json['review_id'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
      listing:
          json['listing'] != null
              ? ListingModel.fromJson(json['listing'])
              : null,
      review:
          json['review'] != null ? ReviewModel.fromJson(json['review']) : null,
      reward:
          json['reward'] != null ? RewardModel.fromJson(json['reward']) : null,
      ratings:
          json['review'] != null ? json['review']['rating'].toDouble() : null,
      reviewStatus: json['review'] != null ? json['review']['status'] : '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'listingId': listingId,
    'bookingDate': bookingDate?.toIso8601String(),
    'booking_hours': bookingHours,
    'additionalNote': additionalNote,
    'ageGroup': ageGroup,
    'numberOfPersons': numberOfPersons,
    'paymentMethod': paymentMethod,
    'status': status,
    'review_id': reviewId,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'listing': listing?.toJson(),
    'review': review?.toJson(),
    'reward': reward?.toJson(),
  };

  @override
  String toString() {
    return 'BookingModel(id: $id, status: $status, date: $bookingDate, listing: ${listing?.name}, rewardPoints: ${reward?.points})';
  }
}
