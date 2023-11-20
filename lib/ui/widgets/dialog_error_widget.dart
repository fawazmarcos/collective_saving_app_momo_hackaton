import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogErrorWidget {
  static void show(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          "Erreur",
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        content: Text(
          msg,
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("D'accord"),
          ),
        ],
      ),
    );
  }
}
