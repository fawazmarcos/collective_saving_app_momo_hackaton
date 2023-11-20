import 'package:epargne_collective/Models/transaction.dart';
import 'package:epargne_collective/repositories/data_repository.dart';
import 'package:epargne_collective/ui/screens/historique_transaction.dart';
import 'package:epargne_collective/ui/widgets/appbar_widget.dart';
import 'package:epargne_collective/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueListenable<int> counter = ValueNotifier<int>(0);

  List<TransactionModel> transactionsList = [];
  int fondsTotal = 0;
  int depotsTotal = 0;
  int retraitsTotal = 0;

  bool isDataInitialized = false;

  @override
  void initState() {
    super.initState();
    setState(() {}); //Pour reconstruire la page quand on vient sur ça
    if (!isDataInitialized) {
      initData();
      isDataInitialized = true;
    }
  }

  Future<void> initData() async {
    try {
      final dataProvider = Provider.of<DataRepository>(context, listen: false);
      transactionsList = dataProvider.transactionsList;

      depotsTotal = transactionsList
          .where((transaction) => transaction.typeTransaction == 'Dépôt')
          .map((transaction) => transaction.montant)
          .fold(0, (acc, montant) => acc + montant);

      retraitsTotal = transactionsList
          .where((transaction) => transaction.typeTransaction == 'Retrait')
          .map((transaction) => transaction.montant)
          .fold(0, (acc, montant) => acc + montant);

      //Total fonds disponible pour toute les souscriptions
      fondsTotal = dataProvider.souscriptionsList
          .map((souscription) => souscription.montantPaye)
          .fold(0, (acc, montant) => acc + montant);
    } catch (e) {
      print("Erreur home : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataRepository>(context);
    return Scaffold(
        appBar: AppBarWidget(
          title: "Epargne collective",
        ),
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: 340, child: _head()),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Historique des transactions',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                        color: blackColor,
                      ),
                    ),
                    TextButton(
                      child: Text('Tout voir',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.grey,
                          )),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoriqueTransaction()));
                      },
                    ),
                  ],
                ),
              ),
            ),
            dataProvider.transactionsList.isEmpty
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              "Aucune transaction effectuée",
                              style: GoogleFonts.poppins(
                                  color: blackColor, fontSize: 16),
                            ),
                          ],
                        );
                      },
                      childCount: 1,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return get(dataProvider.transactionsList[index], index);
                      },
                      childCount: dataProvider.transactionsList.length >= 5
                          ? 5
                          : dataProvider.transactionsList.length,
                    ),
                  ),
          ],
        )));
  }

  Widget _head() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    left: 340,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: const Color.fromRGBO(250, 250, 250, 0.1),
                        child: const Icon(
                          Icons.notification_add_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bonjour',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: const Color.fromARGB(255, 224, 223, 223),
                          ),
                        ),
                        Text(
                          nomUser,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 140,
          left: 37,
          child: Container(
            height: 170,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(47, 125, 121, 0.3),
                  offset: Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: 6,
                ),
              ],
              color: primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fonds total',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        '$fondsTotal CFA',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'Dépôts',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: const Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'Retraits',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: const Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$depotsTotal CFA',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '$retraitsTotal CFA',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
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
