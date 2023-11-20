// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:epargne_collective/ui/screens/login.dart';
import 'package:epargne_collective/ui/screens/souscription_detail.dart';
import 'package:epargne_collective/utils/constant.dart';
import 'package:flutter/material.dart';

import 'package:epargne_collective/Models/souscription.dart';
import 'package:google_fonts/google_fonts.dart';

class SouscriptionWidget extends StatelessWidget {
  SouscriptionModel souscription;
  SouscriptionWidget({
    Key? key,
    required this.souscription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.blue[100],
        onTap: () => {
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SouscriptionDetail(souscription: souscription);
            }));
          })
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Icon(
              Icons.savings_outlined,
              size: 40,
              color: primaryColor,
            ),
          ),
          title: Text(
            souscription.typeEpargne!.libelle,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: souscription.bloque
              ? Text(
                  "Compte bloqué",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Text(
                  "Compte ouvert",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
          trailing: Text(
            "CFA ${souscription.montantPaye.toString()}",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 19,
            ),
          ),
        ),
      ),
    );
  }
}
