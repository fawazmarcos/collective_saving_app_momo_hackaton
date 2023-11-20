import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:epargne_collective/ui/screens/loading_after_lgin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:epargne_collective/ui/screens/login.dart';
import 'package:epargne_collective/utils/constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool auth = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        //Initialisation de la variable globale transporteurId
        idUser = prefs.getString('idUser') ?? "";
        nomUser = prefs.getString('nomUser') ?? "";
        telephoneUser = prefs.getString('telephoneUser') ?? "";
        auth = prefs.getBool('auth') ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: 1000,
        splash: const Icon(
          Icons.savings,
          color: Colors.white,
          size: 70,
        ),
        nextScreen: (auth == true) ? const LoadingAfterLogin() : const Login(),
        splashTransition: SplashTransition.rotationTransition,
        backgroundColor: primaryColor);
  }
}
