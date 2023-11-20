import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epargne_collective/Models/souscription.dart';
import 'package:epargne_collective/Models/transaction.dart';
import 'package:epargne_collective/repositories/data_repository.dart';
import 'package:epargne_collective/services/api_service.dart';
import 'package:epargne_collective/ui/screens/home_screen.dart';
import 'package:epargne_collective/ui/screens/nav_bottom.dart';
import 'package:epargne_collective/ui/widgets/appbar_widget.dart';
import 'package:epargne_collective/ui/widgets/dialog_error_widget.dart';
import 'package:epargne_collective/ui/widgets/snackbar_success_widget.dart';
import 'package:epargne_collective/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Paiement extends StatefulWidget {
  const Paiement({super.key});

  @override
  State<Paiement> createState() => _PaiementState();
}

class _PaiementState extends State<Paiement> {
  String telephone = telephoneUser.substring(4); //Retirer le +229 du numéro

  List<SouscriptionModel> souscriptonsList = [];
  List<String> epargnesList = ["Epargne souhaité"];

  String epargne = "Epargne souhaité";
  late String idSouscription;
  late int montant;
  bool isDataInitialized = false;

  Widget submitButton = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.payment,
        color: Colors.white,
      ),
      const SizedBox(
        width: 5.0,
      ),
      Text(
        "Payer",
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.0),
      ),
    ],
  );
  //Bouton appelé lorsque login échoué
  Widget submitAgain = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.payment,
        color: Colors.white,
      ),
      const SizedBox(
        width: 5.0,
      ),
      Text(
        "Payer",
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
      "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
  @override
  void initState() {
    super.initState();
    if (!isDataInitialized) {
      initData();
      isDataInitialized = true;
    }
  }

  Future<void> initData() async {
    try {
      final dataProvider = Provider.of<DataRepository>(context, listen: false);
      souscriptonsList = dataProvider.souscriptionsList;
      //Ajoutons le libellé des types épargnes dans le tableau
      for (SouscriptionModel souscription in souscriptonsList) {
        epargnesList.add(souscription.typeEpargne!.libelle);
      }
    } catch (e) {
      print("Erreur home : $e");
    }
  }

  //Retouner l'id de l'épargne à partir du libelle
  void setidSouscription(val) {
    for (var item in souscriptonsList) {
      if (item.typeEpargne!.libelle == val) {
        setState(() {
          idSouscription = item.id;
        });
      }
    }
  }

  sendFormData() async {
    APISERVICE apiservice = APISERVICE();

    final dataProvider =
        await Provider.of<DataRepository>(context, listen: false);

    try {
      setState(() {
        submitButton = afterSubmit;
      });

      /*--- Appel à l'api momo pour validation du paiement -----*/
      var data = {
        'telephone': "299$telephone",
        'montant': montant,
      };
      Map _data = await apiservice.addPaiement(data: data);

      //Si paiement effectué
      if (_data['status'] == 200) {
        _formKey.currentState!.reset();

        // Sauvegarde des données liés à la transaction dans firestore
        final docTransaction =
            FirebaseFirestore.instance.collection("transactions").doc();

        //Données à sauvegarder
        var transaction = {
          "id": docTransaction.id,
          "typeTransaction": "Dépôt",
          "idUtilisateur": idUser,
          "createdAt": createdAt,
          "montant": montant,
          "idSouscription": idSouscription,
          "date": Timestamp.fromDate(
              DateTime.now()) // A revoir, si je dois enlever ou pas
        };

        //Sauvagarde des données
        await docTransaction.set(transaction).then((value) {
          dataProvider.transactionsList
              .add(TransactionModel.fromJson(transaction));
          dataProvider.updateTransactionsList(dataProvider.transactionsList);

          //Augmenter la variable montantPaye dans souscription
          CollectionReference souscriptionsCollection =
              FirebaseFirestore.instance.collection('souscriptions');

          // Mettre à jour la souscription dans Firestore
          souscriptionsCollection.doc(idSouscription).update({
            'montantPaye': FieldValue.increment(montant),
          }).then((value) {
            //Mettre à jour dans la liste souscription
            //Récupération de l'index de la souscription
            int indexSouscription = dataProvider.souscriptionsList
                .indexWhere((element) => element.id == idSouscription);

            //Mettre à jour le champs montantPaye
            if (indexSouscription != -1) {
              dataProvider.souscriptionsList[indexSouscription].montantPaye +=
                  montant;

              //Message succès
              SnackBarSuccessWidget.show(
                  context, "Paiement effectué avec succès");

              //Rediriger vers page acceuil
              Future.delayed(const Duration(microseconds: 2500), () {
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Bottom();
                  }));
                });
              });
            }
          }).catchError((error) {
            print(
                "Erreur lors de la mise à jour de la souscription dans Firestore: $error");
          });
        }).catchError((onError) => {print(onError)});

        setState(() {
          submitButton = submitAgain;
        });
      } else {
        setState(() {
          submitButton = submitAgain;
        });

        DialogErrorWidget.show(context, _data['message']);
      }
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
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: "Paiement",
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
                      _buildEpargneField(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildTelephoneViseField(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _buildMontantField(),
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

  // Création de la liste déroulante des epargnes
  Widget _buildEpargneField() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 1.1,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(50)),
          child: DropdownButton<String>(
            value: epargne,
            items: epargnesList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Text(value)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                epargne = newValue!;
                setidSouscription(newValue);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTelephoneViseField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: telephone,
            decoration: InputDecoration(
              labelText: "Téléphone",
              hintText: "Le numéro MoMo",
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
            onSaved: (String? value) => telephone = value!,
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
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Montant",
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
            onSaved: (String? value) => montant = int.parse(value!),
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
