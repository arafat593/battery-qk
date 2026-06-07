class ReviewModel {
  final int? id;
  final int? userId;
  final int? listingId;
  final int? rating;
  final String? status;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReviewModel({
    this.id,
    this.userId,
    this.listingId,
    this.rating,
    this.status,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      userId: json['userId'],
      listingId: json['listingId'],
      rating: json['rating'],
      status: json['status'],
      comment: json['comment'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'listingId': listingId,
    'rating': rating,
    'status': status,
    'comment': comment,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  @override
  String toString() {
    return 'ReviewModel(rating: $rating, comment: "$comment")';
  }
}
