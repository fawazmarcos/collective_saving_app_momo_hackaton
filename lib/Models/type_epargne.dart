import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class TypeEpargneModel {
  String id;
  String libelle;
  String? description;
  bool bourse;
  bool
      pardefaut; //Pour déterminer si c'est un type épargne créé par nous ou l'user
  String createdAt;

  TypeEpargneModel({
    required this.id,
    required this.libelle,
    this.description,
    required this.bourse,
    required this.pardefaut,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'libelle': libelle,
      'description': description,
      'bourse': bourse,
      'pardefaut': pardefaut,
      'createdAt': createdAt,
    };
  }

  factory TypeEpargneModel.fromMap(DocumentSnapshot document) {
    var data = document.data() as Map;
    Map map = data;
    return TypeEpargneModel(
      id: map['id'] as String,
      libelle: map['libelle'] as String,
      bourse: map['bourse'] as bool,
      pardefaut: map['pardefaut'] as bool,
      description:
          map['description'] != null ? map['description'] as String : null,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());
}
