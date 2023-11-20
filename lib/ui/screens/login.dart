import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epargne_collective/Models/user.dart';
import 'package:epargne_collective/ui/screens/inscription.dart';
import 'package:epargne_collective/ui/screens/loading_after_lgin.dart';
import 'package:epargne_collective/ui/widgets/dialog_error_widget.dart';
import 'package:epargne_collective/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String identifiant;
  late String password;
  //Bouton login
  Widget submitButton = Row(
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
        "Connexion",
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
        "Connexion",
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
        "Un instant",
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.0),
      )
    ],
  );

  sendFormData() async {
    try {
      //Remise
      setState(() {
        submitButton = afterSubmit;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          //Si téléphone n'existe pas
          if ((doc['telephone'] == identifiant) &&
              doc['password'] == password) {
            //Convertir la data en un objet de type UserModel
            //Sauvegarder ça dans une variable constante

            userInstance = UserModel.fromMap(doc);

            idUser = userInstance.uid;
            nomUser = userInstance.fullname;
            telephoneUser = userInstance.telephone;

            //Local storage
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('idUser', idUser);
            prefs.setString('nomUser', userInstance.fullname);
            prefs.setString('telephoneUser', telephoneUser);
            prefs.setBool('auth', true);

            redirect(); //Redirection vers la page d'accueil
          } else {
            setState(() {
              submitButton = submitAgain;
            });
            DialogErrorWidget.show(
                context, "Identifiant ou mot de passe incorrecte");
          }
        }
      });
    } catch (e) {
      setState(() {
        submitButton = submitAgain;
      });
      print(e);
      DialogErrorWidget.show(
          context, "Une erreur s'est produite, veuillez réessayer");
      //Affiche le code au cas l'erreur n'est pas traité
    }
  }

  //Fonction permettant de rediriger vers la page d'acceuil
  //Fonction appelé lorsque identifiant correcte
  redirect() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const LoadingAfterLogin();
    }));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/vector.png",
                height: 220,
              ),
              Text(
                "Connexion",
                style: GoogleFonts.poppins(
                    fontSize: 44.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIdentifiantField(),
                      const SizedBox(
                        height: 26.0,
                      ),
                      _buildPasswordField(),
                      const SizedBox(
                        height: 12.0,
                      ),
                      /*
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Mot de passe oublié?",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(color: Colors.lightBlue),
                        ),
                      ),*/
                      const SizedBox(
                        height: 30.0,
                      ),
                      _buildLoginButtonField(),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextButton(
                        onPressed: (() => {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return const Inscription();
                              }))
                            }),
                        child: Text("Pas de compte? Inscrivez-vous",
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

  Widget _buildIdentifiantField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          hintText: "Entrez votre numéro de téléphone",
          prefixIcon: Icon(
            Icons.phone,
            color: primaryColor,
          )),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Champs obligatoire';
        }
        return null;
      },
      onSaved: (String? value) => identifiant = value!,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      obscureText: true,
      decoration: InputDecoration(
          hintText: "Entrez votre mot de passe",
          prefixIcon: Icon(
            Icons.lock,
            color: primaryColor,
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
