class User {
  final String uid;
  final String fname;
  final String lname;
  final String email;

  User({
    required this.uid,
    required this.fname,
    required this.lname,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      fname: json['fname'],
      lname: json['lname'],
      email: json['email'],
    );
  }

  @override
  String toString() {
    return 'User(uid: $uid, fname: $fname, lname: $lname, email: $email)';
  }
}
