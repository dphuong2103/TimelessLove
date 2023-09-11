import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeless_love_app/models/user.dart';

class Relationship with ChangeNotifier {
  String? id;
  List<String> users;
  DateTime startDate;
  UserModel? partner;
  Relationship({
    required this.users,
    required this.startDate,
    this.id,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) {
    List<dynamic>? usersJson = json['users'];
    List<String> users = [];
    if (usersJson != null && usersJson.isNotEmpty) {
      users = usersJson.map((userJson) => userJson.toString()).toList();
    }

    return Relationship(
      id: json['id'],
      startDate: (json['startDate'] as Timestamp).toDate(),
      users: users,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate,
      'users': users,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'users': users,
      'startDate': startDate,
    };
  }

  factory Relationship.fromFirestore(DocumentSnapshot doc) {
    List<dynamic>? usersJson = doc['users'];
    List<String> users = [];

    if (usersJson != null && usersJson.isNotEmpty) {
      users = usersJson.map((userJson) => userJson.toString()).toList();
    }

    return Relationship(
      id: doc['id'],
      startDate: (doc['startDate'] as Timestamp).toDate(),
      users: users,
    );
  }
}
