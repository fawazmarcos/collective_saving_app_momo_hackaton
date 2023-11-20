// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:epargne_collective/Models/transaction.dart';
import 'package:epargne_collective/repositories/data_repository.dart';
import 'package:epargne_collective/ui/widgets/appbar_widget.dart';
import 'package:epargne_collective/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HistoriqueTransaction extends StatefulWidget {
  String? idSouscription;
  HistoriqueTransaction({
    Key? key,
    this.idSouscription,
  }) : super(key: key);

  @override
  State<HistoriqueTransaction> createState() => _HistoriqueTransactionState();
}

class _HistoriqueTransactionState extends State<HistoriqueTransaction> {
  String idSouscription = "";
  List<TransactionModel> transactionsList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idSouscription = widget.idSouscription ?? "";
    initData();
  }

  Future<void> initData() async {
    try {
      final dataProvider = Provider.of<DataRepository>(context, listen: false);
      transactionsList = idSouscription.isNotEmpty
          ? dataProvider.transactionsList
              .where((element) => element.idSouscription == idSouscription)
              .toList()
          : dataProvider.transactionsList;
    } catch (e) {
      print("Erreur home : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Historique transactions",
      ),
      body: SingleChildScrollView(
        child: transactionsList.isEmpty
            ? Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Aucune transactions effectuées",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: blackColor),
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: transactionsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return get(transactionsList[index], index);
                }),
      ),
    );
  }

  ListTile get(TransactionModel transaction, int index) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Icon(
          Icons.savings_outlined,
          size: 40,
          color: primaryColor,
        ),
      ),
      title: Text(
        transaction.typeTransaction,
        style: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        transaction.createdAt,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        "${transaction.montant.toString()} CFA",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 19,
          color: transaction.typeTransaction == 'Dépôt'
              ? Colors.green
              : Colors.red,
        ),
      ),
    );
  }
}
