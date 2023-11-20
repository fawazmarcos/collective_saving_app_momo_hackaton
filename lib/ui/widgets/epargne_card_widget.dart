import 'package:epargne_collective/Models/type_epargne.dart';
import 'package:epargne_collective/ui/screens/souscription.dart';
import 'package:epargne_collective/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

class EpargneCardWidget extends StatelessWidget {
  final TypeEpargneModel epargne;
  const EpargneCardWidget({super.key, required this.epargne});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: primaryColor,
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              //color: kbcprimary,
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, Colors.orange])),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  epargne.libelle,
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: whiteColor,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: ReadMoreText(
                  textAlign: TextAlign.justify,
                  epargne.description != null ? epargne.description! : '',
                  style: GoogleFonts.poppins(fontSize: 14, color: whiteColor),
                  lessStyle:
                      GoogleFonts.poppins(fontSize: 14, color: blackColor),
                  moreStyle:
                      GoogleFonts.poppins(fontSize: 14, color: blackColor),
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: " Lire plus ",
                  trimExpandedText: " Lire moins ",
                  delimiterStyle:
                      GoogleFonts.poppins(fontSize: 14, color: whiteColor),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subvention: ${epargne.bourse ? 'Oui' : 'Non'}",
                      style:
                          GoogleFonts.poppins(fontSize: 14, color: whiteColor),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Souscription(typeEpargne: epargne);
                        }));
                      },
                      child: Text('Souscrire'),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
    ;
  }
}
