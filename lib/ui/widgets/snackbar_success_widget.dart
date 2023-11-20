import 'package:epargne_collective/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SnackBarSuccessWidget {
  SnackBarSuccessWidget(BuildContext context, String s);

  static void show(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: primaryColor,
        action: SnackBarAction(
          label: 'Ok',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
