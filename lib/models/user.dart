import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { male, female, other }

class UserModel {
  String? uid;
  String? displayName;
  String? photoURL;
  String email;
  Gender? gender;
  DateTime? birthDate;
  String? fmToken;
  UserModel({
    this.uid,
    this.gender,
    this.displayName,
    required this.email,
    this.photoURL,
    this.birthDate,
    this.fmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      email: json['email'],
      fmToken: json['fmToken'],
      gender: json['gender'] != null
          ? Gender.values.byName(json['gender'].toString().toLowerCase())
          : null,
      birthDate: json['birthDate'] != null
          ? (json['birthDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoURL': photoURL,
        'gender': gender?.name,
        'birthDate': birthDate,
        'fmToken': fmToken,
      };
}
