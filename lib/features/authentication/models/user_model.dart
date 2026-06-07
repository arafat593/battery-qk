class UserModel {
  final int? id;
  final String? email;
  final String? fname;
  final String? lname;
  final String? uid;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? totalRewardPoints;
  final String? highestRewardCategory;

  UserModel({
    this.id,
    this.email,
    this.fname,
    this.lname,
    this.uid,
    this.createdAt,
    this.updatedAt,
    this.totalRewardPoints,
    this.highestRewardCategory,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      email: json['email'] as String?,
      fname: json['fname'] as String?,
      lname: json['lname'] as String?,
      uid: json['uid'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      totalRewardPoints: json['totalRewardPoints'] as int?,
      highestRewardCategory: json['highestRewardCategory'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fname': fname,
      'lname': lname,
      'uid': uid,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'totalRewardPoints': totalRewardPoints,
      'highestRewardCategory': highestRewardCategory,
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, fname: $fname, lname: $lname, uid: $uid, createdAt: $createdAt, updatedAt: $updatedAt, totalRewardPoints: $totalRewardPoints, highestRewardCategory: $highestRewardCategory)';
  }
}
