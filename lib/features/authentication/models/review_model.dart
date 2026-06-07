class Review {
  final int rating;
  final String comment;
  final String createdAt;
  final String user;

  Review({
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      createdAt: json['createdAt'] as String,
      user: json['user'] as String,
    );
  }
}
