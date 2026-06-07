class ReviewSubmitModel {
  final int bookingId;
  final int rating;
  final String comment;

  ReviewSubmitModel({
    required this.bookingId,
    required this.rating,
    required this.comment,
  });

  factory ReviewSubmitModel.fromJson(Map<String, dynamic> json) {
    return ReviewSubmitModel(
      bookingId: json['bookingId'],
      rating: json['rating'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'rating': rating,
      'comment': comment,
    };
  }
}
