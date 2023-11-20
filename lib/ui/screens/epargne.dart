import 'package:epargne_collective/Models/souscription.dart';
import 'package:epargne_collective/Models/type_epargne.dart';
import 'package:epargne_collective/repositories/data_repository.dart';
import 'package:epargne_collective/ui/widgets/appbar_widget.dart';
import 'package:epargne_collective/ui/widgets/epargne_card_widget.dart';
import 'package:epargne_collective/ui/widgets/souscription_widget.dart';
import 'package:epargne_collective/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Epargne extends StatefulWidget {
  const Epargne({super.key});

  @override
  State<Epargne> createState() => _EpargneState();
}

class _EpargneState extends State<Epargne> {
  List<TypeEpargneModel> typesEpargneList = [];
  List<SouscriptionModel> souscriptionsList = [];

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
      typesEpargneList = dataProvider.typesEpargneList;
      souscriptionsList = dataProvider.souscriptionsList;
    } catch (e) {
      print("Erreur home : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: "Type épargne",
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final epargne = typesEpargneList[index];
                  return EpargneCardWidget(epargne: epargne);
                },
                childCount: typesEpargneList.length,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vos souscriptions',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                        color: blackColor,
                      ),
                    ),
                    Icon(
                      Icons.add,
                      color: primaryColor,
                      size: 30,
                    )
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          child: souscriptionsList.isEmpty
              ? Center(
                  child: Text(
                    "Vous n'avez souscrit à aucune épargne pour le moment",
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: souscriptionsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SouscriptionWidget(
                      souscription: souscriptionsList[index],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
