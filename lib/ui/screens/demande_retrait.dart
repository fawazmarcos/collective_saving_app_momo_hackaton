import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epargne_collective/Models/souscription.dart';
import 'package:epargne_collective/repositories/data_repository.dart';
import 'package:epargne_collective/ui/widgets/appbar_widget.dart';
import 'package:epargne_collective/ui/widgets/dialog_error_widget.dart';
import 'package:epargne_collective/ui/widgets/snackbar_success_widget.dart';
import 'package:epargne_collective/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DemandeRetrait extends StatefulWidget {
  final SouscriptionModel souscription;
  DemandeRetrait({super.key, required this.souscription});

  @override
  State<DemandeRetrait> createState() => _DemandeRetraitState();
}

class _DemandeRetraitState extends State<DemandeRetrait> {
  late SouscriptionModel souscription;
  late String typeEpargne;
  late String telephone;
  late String montant;

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
        "Valider",
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.0),
      ),
    ],
  );
  //Bouton appelé lorsque login échoué
  Widget submitAgain = Row(
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
  var createdAt =
      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
  @override
  void initState() {
    super.initState();
    souscription = widget.souscription;
  }

  sendFormData() async {
    final dataProvider =
        await Provider.of<DataRepository>(context, listen: false);

    try {
      setState(() {
        submitButton = afterSubmit;
      });
      //Préparation de l'instance pour sauvegarde dans firestore
      final docRetrait =
          FirebaseFirestore.instance.collection("demandes_retrait").doc();

      var jsonData = {
        "id": docRetrait.id,
        "idSouscriptio,": souscription.id,
        "idUtilisateur": idUser,

        "createdAt": createdAt,
        "traitement": 0,

        "date": Timestamp.fromDate(
            DateTime.now()) // A revoir, si je dois enlever ou pas
      };

      await docRetrait.set(jsonData).then((value) {
        CollectionReference souscriptionsCollection =
            FirebaseFirestore.instance.collection('souscriptions');

        // Mettre à jour la souscription dans Firestore
        souscriptionsCollection.doc(souscription.id).update({
          'status': 2,
        }).then((value) {
          //Mettre à jour dans la liste souscription
          //Récupération de l'index de la souscription
          int indexSouscription = dataProvider.souscriptionsList
              .indexWhere((element) => element.id == souscription.id);

          if (indexSouscription != -1) {
            dataProvider.souscriptionsList[indexSouscription].status = 2;

            //Message succès
            SnackBarSuccessWidget.show(
                context, "Demande de retrait bien effectuée");
          }
        });
      }).catchError((onError) => {print(onError)});
      setState(() {
        submitButton = submitAgain;
      });
    } catch (e) {
      setState(() {
        submitButton = submitAgain;
      });
      print(e);
      DialogErrorWidget.show(
          context, "Une erreur s'est produite, veuillez rééssayeer!");
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Demande retrait"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTypeEpargneField(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildMontantField(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildTelephoneField(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildSubmitButtonField()
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeEpargneField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: souscription.typeEpargne!.libelle,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Type épargne",
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(50)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Champs obligatoire';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMontantField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: souscription.montantPaye.toString(),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Montant à retirer",
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(50)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Champs obligatoire';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTelephoneField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Numéro récepteur des fonds",
              hintText: "61616161", // Ajoutez le texte pré-rempli ici
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
                borderRadius: BorderRadius.circular(50),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Champs obligatoire';
              }
              return null;
            },
            onSaved: (String? value) => telephone = value!,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButtonField() {
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
