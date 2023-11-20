// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epargne_collective/ui/widgets/appbar_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:epargne_collective/Models/souscription.dart';
import 'package:epargne_collective/Models/type_epargne.dart';
import 'package:epargne_collective/repositories/data_repository.dart';
import 'package:epargne_collective/ui/widgets/dialog_error_widget.dart';
import 'package:epargne_collective/ui/widgets/snackbar_success_widget.dart';
import 'package:epargne_collective/utils/constant.dart';

class Souscription extends StatefulWidget {
  TypeEpargneModel typeEpargne;
  Souscription({
    Key? key,
    required this.typeEpargne,
  }) : super(key: key);

  @override
  State<Souscription> createState() => _SouscriptionState();
}

class _SouscriptionState extends State<Souscription> {
  late TypeEpargneModel typeEpargne;

  bool bloque = false;
  DateTime? dateRetraitPrevu;
  int? montantVise;

  var createdAt =
      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
  var date = DateTime.now();
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
        "Souscrire",
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
        "Souscrire",
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
    // TODO: implement initState
    super.initState();
    typeEpargne = widget.typeEpargne;
  }

  sendFormData() async {
    final dataProvider =
        await Provider.of<DataRepository>(context, listen: false);
    try {
      setState(() {
        submitButton = afterSubmit;
      });
      //Préparation de l'instance pour sauvegarde dans firestore
      final docSouscription =
          FirebaseFirestore.instance.collection("souscriptions").doc();

      var jsonData = {
        "id": docSouscription.id,
        "idTypeEpargne": typeEpargne.id,
        "idUtilisateur": idUser,
        "montantPaye": 0,
        "bloque": bloque,
        "createdAt": createdAt,
        "status": 1,
        "dateRetraitPrevu": bloque ? dateRetraitPrevu : null,
        "montantVise": bloque ? montantVise : null,
        "date": Timestamp.fromDate(
            DateTime.now()) // A revoir, si je dois enlever ou pas
      };

      await docSouscription.set(jsonData).then((value) {
        jsonData["typeEpargne"] = typeEpargne;
        var souscription = SouscriptionModel.fromJson(jsonData);
        dataProvider.souscriptionsList.add(souscription);
        dataProvider.updateSouscriptionsList(dataProvider.souscriptionsList);
        SnackBarSuccessWidget.show(context, "Souscirpton réussi");
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
      appBar: AppBarWidget(
        title: "Souscription",
      ),
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
                      _buildMontantViseField(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      if (bloque) _buildDateRetraitField(),
                      _buildBloqueField(),
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
            initialValue: typeEpargne.libelle,
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

  Widget _buildBloqueField() {
    return Row(
      children: [
        Expanded(
          child: CheckboxListTile(
            title: Text(
              'Bloquer les sous à une date précise?',
              style: GoogleFonts.poppins(color: blackColor, fontSize: 14),
            ),
            value: bloque,
            onChanged: (bool? value) {
              setState(() {
                bloque = value!;
              });
            },
            activeColor: primaryColor,
            controlAffinity:
                ListTileControlAffinity.leading, // Met le Checkbox à gauche
          ),
        ),
      ],
    );
  }

  Widget _buildMontantViseField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Montant visé",
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
            onSaved: (String? value) => montantVise = int.parse(value!),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRetraitField() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(50))),
            child: Row(
              children: [
                Expanded(
                    child: dateRetraitPrevu != null
                        ? Text(
                            DateFormat('dd-MM-yyyy').format(dateRetraitPrevu!))
                        : const Text("")),
                //Icon à droite
                IconButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != dateRetraitPrevu) {
                      setState(() {
                        dateRetraitPrevu = picked;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.date_range,
                    color: primaryColor,
                    size: 30,
                  ),
                ),
              ],
            ),
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
