import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epargne_collective/ui/screens/login.dart';
import 'package:epargne_collective/ui/screens/verification_telephone.dart';
import 'package:epargne_collective/ui/widgets/dialog_error_widget.dart';
import 'package:epargne_collective/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  String codePays = "+229";
  late String telephone;

  //Bouton submit
  Widget submitButton = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Vérifier",
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.0),
      ),
    ],
  );
  //Bouton appelé lorsque login échoué
  Widget submitAgain = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Vérifier",
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

  //Envoi d'SMS au num pour vérification
  submitForm() async {
    setState(() {
      submitButton = afterSubmit;
    });

    //Vérification de l'existance du numéro dans la bd
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        //Si téléphone n'existe pas
        if (doc['telephone'] != codePays + telephone) {
          //Vérifions l'authenticité du numéro en envoyant un sms
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: "$codePays$telephone",
            verificationCompleted: (PhoneAuthCredential credential) {},
            //Vérification impossible du numéro renseigné
            verificationFailed: (FirebaseAuthException e) {
              setState(() {
                submitButton = submitAgain;
              });
              if (e.code == 'invalid-phone-number') {
                DialogErrorWidget.show(context,
                    "Veuillez vérifier votre numéro de téléphone, il semble être incorrecte");
              } else {
                DialogErrorWidget.show(context,
                    "Erreur lors de la vérification du numéro, veuillez réessayer!");
              }
            },
            //Si SMS envoyé au numéro
            codeSent: (String verificationId, int? resendToken) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return VerificationTelephone(
                  verificationId: verificationId,
                  telephone: codePays + telephone,
                );
              }));
            },
            //Délai d'attente pour la validation du captcha
            timeout: const Duration(seconds: 90),
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
        }
        //Numéro existe déjà
        else {
          setState(() {
            submitButton = submitAgain;
          });
          DialogErrorWidget.show(context,
              "Ce numéro de teléphone est déjà enregistré dans notre base de données. Veuillez vous connecter avec vos identifiants!");
        }
      });
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
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
            Text(
              'Votre numéro de téléphone',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Nous devons vérifier votre numéro de téléphone pour commencer!",
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    //Champs de code pays
                    SizedBox(width: 40, child: buildCodeField()),
                    Text(
                      "|",
                      style:
                          GoogleFonts.poppins(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    //Champs de saisi téléphone
                    Expanded(child: buildTelephoneField())
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //Bouton de vérification
            SizedBox(
              width: double.infinity,
              height: 45,
              child: submitFormField(),
            ),
            const SizedBox(
              height: 10.0,
            ),
            //Bouton de connexion en cas de compte
            TextButton(
              onPressed: (() => {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const Login();
                    }))
                  }),
              child: Text("Vous avez déjà un compte? Connectez-vous",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(color: Colors.lightBlue)),
            ),
          ],
        ),
      ),
    );
  }

  //Formulaire de saisi de code pays
  Widget buildCodeField() {
    return TextFormField(
      initialValue: codePays,
      readOnly: true,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Champs obligatoire';
        }
        return null;
      },
      onSaved: (String? value) => codePays = value!,
    );
  }

//Formulaire de saisi de numéro téléphone
  Widget buildTelephoneField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Numéro de téléphone",
      ),
      validator: (String? value) {
        /*
        if (value == null || value.isEmpty) {
          return 'Champs obligatoire';
        }
        */
        return null;
      },
      onSaved: (String? value) => telephone = value!,
    );
  }

  Widget submitFormField() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          _formKey.currentState!.save();
          submitForm();
        },
        child: submitButton);
  }

  //Boite de dialogue appelée lorsqu'il y'a erreur connexion
  void dialogErr(String msg) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              //title: const Text("Erreur connexion"),
              content: Text(
                msg,
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context, 'Cancel');
                    },
                    child: const Text("D'accord"))
              ],
            ));
  }
}
