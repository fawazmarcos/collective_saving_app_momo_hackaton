// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String id;
  String typeTransaction;
  String idUtilisateur;
  String createdAt;
  int montant;
  String idSouscription;
  Timestamp? date;
  TransactionModel(
      {required this.id,
      required this.typeTransaction,
      required this.idUtilisateur,
      required this.createdAt,
      required this.montant,
      required this.idSouscription,
      this.date});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'typeTransaction': typeTransaction,
      'idUtilisateur': idUtilisateur,
      'createdAt': createdAt,
      'montant': montant,
      'idSouscription': idSouscription,
      'date': date,
    };
  }

  factory TransactionModel.fromMap(DocumentSnapshot document) {
    var data = document.data() as Map;
    Map map = data;
    return TransactionModel(
      id: map['id'] as String,
      typeTransaction: map['typeTransaction'] as String,
      idUtilisateur: map['idUtilisateur'] as String,
      idSouscription: map['idSouscription'] as String,
      createdAt: map['createdAt'] as String,
      montant: map['montant'] as int,
      date: map['date'] != null ? map['date'] : null,
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      typeTransaction: json['typeTransaction'],
      idUtilisateur: json['idUtilisateur'],
      idSouscription: json['idSouscription'],
      createdAt: json['createdAt'],
      montant: json['montant'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'TransactionModel(id: $id, typeTransaction: $typeTransaction, idUtilisateur: $idUtilisateur, idSouscription: $idSouscription, createdAt: $createdAt, montant: $montant)';
  }
}
