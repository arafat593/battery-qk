class RewardModel {
  final int? id;
  final int? userId;
  final int? points;
  final String? description;
  final String? category;
  final int? bookingId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RewardModel({
    this.id,
    this.userId,
    this.points,
    this.description,
    this.category,
    this.bookingId,
    this.createdAt,
    this.updatedAt,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'],
      userId: json['userId'],
      points: json['points'],
      description: json['description'],
      category: json['category'],
      bookingId: json['bookingId'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'points': points,
    'description': description,
    'category': category,
    'bookingId': bookingId,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  @override
  String toString() {
    return 'RewardModel(points: $points, category: $category)';
  }
}
