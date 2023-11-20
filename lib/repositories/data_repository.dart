import 'package:epargne_collective/Models/souscription.dart';
import 'package:epargne_collective/Models/transaction.dart';
import 'package:epargne_collective/Models/type_epargne.dart';
import 'package:epargne_collective/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class DataRepository with ChangeNotifier {
  final APISERVICE apiservice = APISERVICE();
  int _totalFunds = 0;
  int get totalFunds => _totalFunds;

  void updateTotalFunds(int total) {
    _totalFunds = total;
    notifyListeners();
  }

  /*--- Transactions -----*/
  List<TransactionModel> _transactionsList = [];

  List<TransactionModel> get transactionsList => _transactionsList;

  void updateTransactionsList(List<TransactionModel> transactions) {
    _transactionsList = transactions;
    notifyListeners();
  }

  /*------ End transactions -------*/

/*----- Type épargne -----*/

  List<TypeEpargneModel> _typesEpargneList = [];

  List<TypeEpargneModel> get typesEpargneList => _typesEpargneList;

  void updateTypesEpargneList(List<TypeEpargneModel> typesEpargne) {
    _typesEpargneList = typesEpargne;
    notifyListeners();
  }

/*---- End type épargne */

/*------ Souscriptions -------*/
  List<SouscriptionModel> _souscriptionsList = [];

  List<SouscriptionModel> get souscriptionsList => _souscriptionsList;

  void updateSouscriptionsList(List<SouscriptionModel> souscriptions) {
    _souscriptionsList = souscriptions;
    notifyListeners();
  }
/*------- End sousciption ---------*/

  //Récupérer les transactions
  Future<void> getTransactions() async {
    try {
      _transactionsList.clear();
      var transacts = await apiservice.getTransactions();
      _transactionsList.addAll(transacts);
    } catch (e) {
      print("Erreur: $e");
    }
  }

  //Récupérer les types d'épargnes
  Future<void> getTypesEpargne() async {
    try {
      _typesEpargneList.clear();
      var epargnes = await apiservice.getTypesEpargne();
      _typesEpargneList.addAll(epargnes);
    } catch (e) {
      print("Erreur: $e");
    }
  }

  //Liste des souscriptions
  Future<void> getSouscriptions() async {
    try {
      _souscriptionsList.clear();
      var souscriptions = await apiservice.getsouscriptions();
      _souscriptionsList.addAll(souscriptions);
      print(_souscriptionsList[0].montantPaye);
    } catch (e) {
      print("Erreur: $e");
    }
  }

  Future<void> initData() async {
    await Future.wait(
        [getTransactions(), getTypesEpargne(), getSouscriptions()]);
  }

  clearData() {
    transactionsList.clear();
    typesEpargneList.clear();
    souscriptionsList.clear();
  }
}
