// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:epargne_collective/Models/type_epargne.dart';

class SouscriptionModel {
  String id;
  String idTypeEpargne;
  String idUtilisateur;
  int montantPaye; //Montant déjà payé
  int? montantVise; //Montant à atteindre
  bool
      bloque; //Vaut true si l'utilisateur a décidé de retirer les sous qu'à la date échéance
  int? status; //Vaut en cours, ou atteint ...
  DateTime? dateRetraitPrevu; //Date de retrait prévu
  String createdAt;
  final TypeEpargneModel? typeEpargne;
  Timestamp? date;

  SouscriptionModel(
      {required this.id,
      required this.idTypeEpargne,
      required this.idUtilisateur,
      required this.montantPaye,
      this.montantVise,
      required this.bloque,
      this.status,
      this.dateRetraitPrevu,
      required this.createdAt,
      this.typeEpargne,
      this.date});

  SouscriptionModel copyWith({
    String? id,
    String? idTypeEpargne,
    String? idUtilisateur,
    int? montantPaye,
    int? montantVise,
    //Vaut? bloque,
    int? status,
    DateTime? dateRetraitPrevu,
    String? createdAt,
    TypeEpargneModel? typeEpargne,
    Timestamp? date,
  }) {
    return SouscriptionModel(
      id: id ?? this.id,
      idTypeEpargne: idTypeEpargne ?? this.idTypeEpargne,
      idUtilisateur: idUtilisateur ?? this.idUtilisateur,
      montantPaye: montantPaye ?? this.montantPaye,
      montantVise: montantVise ?? this.montantVise,
      bloque: bloque ?? this.bloque,
      status: status ?? this.status,
      dateRetraitPrevu: dateRetraitPrevu ?? this.dateRetraitPrevu,
      createdAt: createdAt ?? this.createdAt,
      typeEpargne: typeEpargne ?? this.typeEpargne,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idTypeEpargne': idTypeEpargne,
      'idUtilisateur': idUtilisateur,
      'montantPaye': montantPaye,
      'montantVise': montantVise,
      'bloque': bloque,
      'status': status,
      'dateRetraitPrevu': dateRetraitPrevu,
      'createdAt': createdAt,
      'typeEpargne': typeEpargne,
      'date': date,
    };
  }

  factory SouscriptionModel.fromMap(DocumentSnapshot document) {
    var data = document.data() as Map;
    Map map = data;
    return SouscriptionModel(
      id: map['id'] as String,
      idTypeEpargne: map['idTypeEpargne'] as String,
      idUtilisateur: map['idUtilisateur'] as String,
      montantPaye: map['montantPaye'] as int,
      montantVise:
          map['montantVise'] != null ? map['montantVise'] as int : null,
      bloque: map['bloque'] as bool,
      status: map['status'] as int,
      dateRetraitPrevu: map['dateRetraitPrevu'] != null
          ? (map['dateRetraitPrevu'] as Timestamp).toDate()
          : null,
      createdAt: map['createdAt'] as String,
      date: map['date'] != null ? map['date'] : null,
    );
  }

  factory SouscriptionModel.fromJson(Map<String, dynamic> json) {
    return SouscriptionModel(
      id: json['id'],
      idTypeEpargne: json['idTypeEpargne'],
      idUtilisateur: json['idUtilisateur'],
      montantPaye: json['montantPaye'],
      bloque: json['bloque'],
      createdAt: json['createdAt'],
      status: json['status'],
      dateRetraitPrevu: json['dateRetraitPrevu'] != null
          ? (json['dateRetraitPrevu']) as DateTime
          : null,
      montantVise: json['montantVise'],
      typeEpargne: json['typeEpargne'] as TypeEpargneModel,
    );
  }

  String toJson() => json.encode(toMap());
}
