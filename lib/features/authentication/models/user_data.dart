import 'package:uuid/uuid.dart';

class UserCreate {
  final String fname;
  final String lname;
  final String email;
  final String password;
  final String uid;


  UserCreate({
    required this.fname,
    required this.lname,
    required this.email,
    required this.password,
    required this.uid,
  });

  factory UserCreate.fromJson(Map<String, dynamic> json) {
    return UserCreate(
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      uid: json['uid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fname': fname,
      'lname': lname,
      'email': email,
      'password': password,
      'uid': uid,
    };
  }
  static String generateUID() {
    var uuid = Uuid();
    return uuid.v4();
  }
}

