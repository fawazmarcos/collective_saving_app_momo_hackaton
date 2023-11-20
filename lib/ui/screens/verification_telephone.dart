import 'package:epargne_collective/ui/screens/inscription_fianl.dart';
import 'package:epargne_collective/ui/widgets/dialog_error_widget.dart';
import 'package:epargne_collective/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class VerificationTelephone extends StatefulWidget {
  final String verificationId;
  final String telephone;
  const VerificationTelephone(
      {super.key, required this.verificationId, required this.telephone});

  @override
  State<VerificationTelephone> createState() => _VerificationTelephoneState();
}

class _VerificationTelephoneState extends State<VerificationTelephone> {
  late String verificationId;
  late String telephone;
  String smsCode = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  //Bouton login
  Widget submitButton = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Valider",
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.0),
      ),
    ],
  );
  //Bouton appelé lorsque login échoué
  Widget submitAgain = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Valider",
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.0),
      ),
    ],
  );
  //Bouton appelé lorsque traitement en couors
  Widget afterSubmit = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SpinKitCircle(color: Colors.white, size: 30),
      const SizedBox(
        width: 5.0,
      ),
      Text(
        "Patientez...",
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.0),
      )
    ],
  );

  @override
  void initState() {
    super.initState();
    verificationId = widget.verificationId;
    telephone = widget.telephone;
  }

  //Vérification du code saisi
  submitForm() async {
    setState(() {
      submitButton = afterSubmit;
    });
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      await auth.signInWithCredential(credential).then((value) {
        User? user = auth.currentUser;
        var uid = user!.uid; //Récupération de l'id de l'user inscrit

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return InscriptionFinal(
            telephone: telephone,
            uid: uid,
          );
        }));
      }).catchError((onError) {
        DialogErrorWidget.show(context,
            "Erreur lors de l'enregistrement du numéro, veuilez réessayer");
      });
    } catch (e) {
      setState(() {
        submitButton = submitAgain;
      });
      //A implémenter$
      DialogErrorWidget.show(
          context, "Erreur lors de la validation du code, veuilez réessayer");
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.poppins(
          fontSize: 20,
          color: const Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/vector.png",
                height: 220,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Vérification du numéro",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Veuillez saisir le code qui vous a été envoyé par SMS",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  showCursor: true,
                  onChanged: (value) => {
                        smsCode = value,
                      }),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      submitForm(); //Envoi du code recu par sms
                    },
                    child: submitButton),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'telephone',
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Modifier numéro ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
