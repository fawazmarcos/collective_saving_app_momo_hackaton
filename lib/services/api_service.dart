import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:epargne_collective/Models/souscription.dart';
import 'package:epargne_collective/Models/transaction.dart';
import 'package:epargne_collective/Models/type_epargne.dart';
import 'package:epargne_collective/utils/constant.dart';

import 'dart:async';

import 'api.dart';

class APISERVICE {
  final API api = API();
  final Dio dio = Dio();
//Compléter , Map<String, dynamic> params à getData
  Future<Response> getData(String path, {Map<String, dynamic>? params}) async {
    String url = api.baseUrl + path;

    Map<String, dynamic> query = {};

    if (params != null) {
      query.addAll(params);
    }

    final response = await dio.get(url, queryParameters: query);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw response;
    }
  }

// Post data with dio, à utiliser pour envoyer des données par post
  Future<Response> postData(String path,
      {Map<String, dynamic>? params, dynamic data}) async {
    String url = api.baseUrl + path;

    Map<String, dynamic> query = {};

    var formData = FormData.fromMap(data);

    if (params != null) {
      query.addAll(params);
    }

    final response = await dio.post(url, data: formData);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw response;
    }
  }

  //Faire un paieme,t
  Future<Map> addPaiement({required dynamic data}) async {
    Response response = await postData('requestpay.php', data: data);

    if (response.statusCode == 200) {
      final data = response.data;
      var _data = jsonDecode(data);
      return _data;
    } else {
      throw response;
    }
  }

//Récupérations des transactions
  Future<List<TransactionModel>> getTransactions() async {
    QuerySnapshot transactionsSnapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('idUtilisateur', isEqualTo: idUser)
        .orderBy('date', descending: true)
        //.limit(10)
        .get();

    List<TransactionModel> transactionsList = transactionsSnapshot.docs
        .map((document) => TransactionModel.fromMap(document))
        .toList();

    return transactionsList;
  }

  //Liste des épargnes

  Future<List<TypeEpargneModel>> getTypesEpargne() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('types_epargne')
        .where('pardefaut', isEqualTo: true)
        .get();

    List<TypeEpargneModel> typesEpargneList = querySnapshot.docs
        .map((document) => TypeEpargneModel.fromMap(document))
        .toList();

    return typesEpargneList;
  }

  //Liste des souscriptions

  Future<List<SouscriptionModel>> getsouscriptions() async {
    List<SouscriptionModel> souscriptionsList = [];

    QuerySnapshot souscriptionsSnapshot = await FirebaseFirestore.instance
        .collection('souscriptions')
        .where('idUtilisateur', isEqualTo: idUser)
        .orderBy('date', descending: true)
        //.limit(10)
        .get();

    final souscriptionsDocs = souscriptionsSnapshot.docs;

    //Liste des types épargnes
    final typesEpargneRef =
        FirebaseFirestore.instance.collection('types_epargne');

    for (final souscriptionDoc in souscriptionsDocs) {
      // On transforme chaque objet du result en un objet de type souscription
      SouscriptionModel souscription =
          SouscriptionModel.fromMap(souscriptionDoc);

      //On récupère l'épargne de cette souscription
      final epargneRef = typesEpargneRef.doc(souscription.idTypeEpargne);
      final epargneDoc = await epargneRef.get();
      final epargne = TypeEpargneModel.fromMap(epargneDoc);

      SouscriptionModel newSouscription =
          souscription.copyWith(typeEpargne: epargne);

      souscriptionsList.add(newSouscription);
    }

    return souscriptionsList;
  }
}
