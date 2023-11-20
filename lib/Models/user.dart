import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String fullname;
  String telephone;
  String profession;
  String? password;
  String createdAt;
  Timestamp date;
  String? pays;
  UserModel({
    required this.uid,
    required this.fullname,
    required this.telephone,
    required this.profession,
    this.password,
    this.pays,
    required this.createdAt,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'fullname': fullname,
      'telephone': telephone,
      'profession': profession,
      'password': password,
      'createdAt': createdAt,
      'date': date,
    };
  }

  factory UserModel.fromMap(DocumentSnapshot document) {
    var data = document.data() as Map;
    Map map = data;
    return UserModel(
      uid: map['uid'] as String,
      fullname: map['fullname'] as String,
      telephone: map['telephone'] as String,
      profession: map['profession'] as String,
      password: map['password'] != null ? map['password'] as String : null,
      pays: map['pays'] != null ? map['pays'] as String : null,
      createdAt: map['createdAt'] as String,
      date: map['date'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());
}
