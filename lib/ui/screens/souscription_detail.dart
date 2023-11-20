// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:epargne_collective/Models/transaction.dart';
import 'package:epargne_collective/repositories/data_repository.dart';
import 'package:epargne_collective/ui/screens/demande_retrait.dart';
import 'package:epargne_collective/ui/screens/historique_transaction.dart';
import 'package:epargne_collective/ui/screens/paiement.dart';
import 'package:epargne_collective/ui/widgets/appbar_widget.dart';
import 'package:epargne_collective/ui/widgets/dialog_error_widget.dart';
import 'package:epargne_collective/utils/constant.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

import 'package:epargne_collective/Models/souscription.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SouscriptionDetail extends StatefulWidget {
  SouscriptionModel souscription;
  SouscriptionDetail({
    Key? key,
    required this.souscription,
  }) : super(key: key);

  @override
  State<SouscriptionDetail> createState() => _SouscriptionDetailState();
}

class _SouscriptionDetailState extends State<SouscriptionDetail>
    with SingleTickerProviderStateMixin {
  late SouscriptionModel souscription;
  List<TransactionModel> transactionsList = [];

  double pourcentageProgression = 0;
  Animation<double>? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
    souscription = widget.souscription;
    initData();
  }

  Future<void> initData() async {
    try {
      final dataProvider = Provider.of<DataRepository>(context, listen: false);
      transactionsList = dataProvider.transactionsList
          .where((transaction) => transaction.idSouscription == souscription.id)
          .toList();
      //Calcul de la progression en %
      double montantPaye = souscription.montantPaye.toDouble();
      double montantVise = souscription.montantVise?.toDouble() ?? 0.0;
      pourcentageProgression = (montantPaye / montantVise) * 100;
    } catch (e) {
      print("Erreur home : $e");
    }
  }

  demandeRetrait() {
    //Demande de retrait
    if (souscription.bloque &&
        DateTime.now().isBefore(souscription.dateRetraitPrevu!)) {
      // La date de retrait prévu n'est pas encore arrivée pour un compte bloqué.

      DialogErrorWidget.show(context,
          "Le retrait n'est pas encore autorisé. Date de retrait prévue : ${souscription.dateRetraitPrevu}");

      return;
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DemandeRetrait(souscription: souscription);
      }));
    }
  }

  demandeSubvention() {
    //Demande de retrait
    if (souscription.bloque &&
        DateTime.now().isBefore(souscription.dateRetraitPrevu!)) {
      // La date de retrait prévu n'est pas encore arrivée pour un compte bloqué.

      DialogErrorWidget.show(context,
          "La demande de subvention ne peut pas être émise. Date de retrait prévue : ${souscription.dateRetraitPrevu}");

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: "Détails souscription",
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
                                builder: (context) => HistoriqueTransaction(
                                      idSouscription: souscription.id,
                                    )));
                      },
                    ),
                  ],
                ),
              ),
            ),
            transactionsList.isEmpty
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
                        return get(transactionsList[index], index);
                      },
                      childCount: transactionsList.length >= 5
                          ? 5
                          : transactionsList.length,
                    ),
                  ),
          ],
        )),
        floatingActionButton: FloatingActionBubble(
          items: <Bubble>[
            Bubble(
              title: "Payer",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.payment,
              titleStyle:
                  GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              onPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Paiement()));
              },
            ),
            Bubble(
              title: "Demande de subvention",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.settings,
              titleStyle:
                  GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              onPress: () {
                demandeSubvention();
              },
            ),
            Bubble(
              title: "Demande de retrait",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.arrow_upward,
              titleStyle:
                  GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              onPress: () {
                demandeRetrait();
              },
            ),
          ],
          animation: _animation!,
          onPress: () => _animationController!.isCompleted
              ? _animationController!.reverse()
              : _animationController!.forward(),
          backGroundColor: Colors.blue,
          iconColor: Colors.white,
          iconData: Icons.menu,
        ));
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
                          "Type d'épargne",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: const Color.fromARGB(255, 224, 223, 223),
                          ),
                        ),
                        Text(
                          souscription.typeEpargne!.libelle,
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
            height: 175,
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
                LinearProgressIndicator(
                  value: pourcentageProgression / 100,
                  backgroundColor: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.orange),
                  minHeight: 5,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fonds disponible',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Tooltip(
                        message:
                            'Date de retrait prévu : ${souscription.dateRetraitPrevu}',
                        child: Container(
                          height: 30,
                          width: 30,
                          color: const Color.fromRGBO(250, 250, 250, 0.1),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.orange,
                          ),
                        ),
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
                        '${souscription.montantPaye} CFA',
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
                            backgroundColor: Colors.orange,
                            child: Icon(
                              Icons.money,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'Fonds visé',
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
                            backgroundColor: Colors.orange,
                            child: Icon(
                              Icons.local_atm,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'Subventionné',
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
                        '${souscription.montantVise} CFA',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        souscription.bloque ? 'Oui' : 'Non',
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
        transaction.montant.toString(),
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
