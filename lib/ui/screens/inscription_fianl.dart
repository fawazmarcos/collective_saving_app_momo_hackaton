import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epargne_collective/Models/user.dart';
import 'package:epargne_collective/ui/screens/login.dart';
import 'package:epargne_collective/ui/widgets/dialog_error_widget.dart';
import 'package:epargne_collective/ui/widgets/snackbar_success_widget.dart';
import 'package:epargne_collective/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class InscriptionFinal extends StatefulWidget {
  final String telephone;
  final String uid;
  const InscriptionFinal(
      {super.key, required this.telephone, required this.uid});

  @override
  State<InscriptionFinal> createState() => _InscriptionFinalState();
}

class _InscriptionFinalState extends State<InscriptionFinal> {
  late String telephone;
  late String uid;

  Widget submitButton = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.app_registration,
        color: Colors.white,
      ),
      const SizedBox(
        width: 5.0,
      ),
      Text(
        "Inscription",
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.0),
      ),
    ],
  );
  //Bouton appelé lorsque login échoué
  Widget submitAgain = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.login,
        color: Colors.white,
      ),
      const SizedBox(
        width: 5.0,
      ),
      Text(
        "Inscription",
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

  late String fullname;
  late String profession;
  late String password;
  late String passwordConfirm;
  var createdAt =
      "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
  var date = Timestamp.now();

  @override
  void initState() {
    super.initState();
    telephone = widget.telephone;
    uid = widget.uid;
  }

  sendFormData() async {
    if (password != passwordConfirm) {
      DialogErrorWidget.show(
          context, "Les deux mots de passe saisis ne sont pas identique");
    } else {
      try {
        setState(() {
          submitButton = afterSubmit;
        });
        //Inscription d'un user

        var userjson = UserModel(
                uid: uid,
                fullname: fullname,
                telephone: telephone,
                profession: profession,
                password: password,
                createdAt: createdAt,
                date: date)
            .toMap();

        //Sauvegarde des infos de l'user dans la table user
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .set(userjson)
            .then((value) => {
                  setState(() {
                    submitButton = submitAgain;
                  }),
                  SnackBarSuccessWidget.show(
                      context, "Inscription réussi, veuillez vous connecter!"),
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()))
                })
            .catchError((c) => {
                  DialogErrorWidget.show(context,
                      "Une erreur s'est produite lors de l'enregistrement, veuillez rééssayer!")
                });
      } catch (e) {
        setState(() {
          submitButton = submitAgain;
        });

        DialogErrorWidget.show(
            context, "Une erreur s'est produite, veuillez rééssayer!");
      }
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/vector.png",
                height: 170,
              ),
              Text(
                "Inscription",
                style: GoogleFonts.poppins(
                    fontSize: 44.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNameField(),
                      const SizedBox(
                        height: 26.0,
                      ),
                      _buildProfessionField(),
                      const SizedBox(
                        height: 26.0,
                      ),
                      _buildPasswordField(),
                      const SizedBox(
                        height: 38.0,
                      ),
                      _buildPasswordConfirmField(),
                      const SizedBox(
                        height: 38.0,
                      ),
                      _buildLoginButtonField(),
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextButton(
                        onPressed: (() => {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()))
                            }),
                        child: Text("Déjà un compte? Connectez-vous",
                            textAlign: TextAlign.start,
                            style:
                                GoogleFonts.poppins(color: Colors.lightBlue)),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      //autofocus: true,
      decoration: const InputDecoration(
          hintText: "Entrez votre nom complet",
          prefixIcon: Icon(
            Icons.person,
            color: Colors.black,
          )),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Champs obligatoire';
        }
        return null;
      },
      onSaved: (String? value) => fullname = value!,
    );
  }

  Widget _buildProfessionField() {
    return TextFormField(
      decoration: const InputDecoration(
          hintText: "Entrez votre profession",
          prefixIcon: Icon(
            Icons.work,
            color: Colors.black,
          )),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Champs obligatoire';
        }
        return null;
      },
      onSaved: (String? value) => profession = value!,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
          hintText: "Entrez votre mot de passe",
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.black,
          )),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Champs obligatoire';
        }
        return null;
      },
      onSaved: (String? value) => password = value!,
    );
  }

  Widget _buildPasswordConfirmField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
          hintText: "Confirmez votre mot de passe",
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.black,
          )),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Champs obligatoire';
        }
        return null;
      },
      onSaved: (String? value) => passwordConfirm = value!,
    );
  }

  Widget _buildLoginButtonField() {
    return SizedBox(
      width: double.infinity,
      child: RawMaterialButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();
            sendFormData();
          },
          elevation: 0,
          fillColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: submitButton),
    );
  }
}
