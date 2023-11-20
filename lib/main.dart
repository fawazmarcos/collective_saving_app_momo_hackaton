import 'package:epargne_collective/firebase_options.dart';
import 'package:epargne_collective/repositories/data_repository.dart';
import 'package:epargne_collective/ui/screens/inscription.dart';
import 'package:epargne_collective/ui/screens/inscription_fianl.dart';
import 'package:epargne_collective/ui/screens/login.dart';
import 'package:epargne_collective/ui/screens/splash_screen.dart';
import 'package:epargne_collective/ui/screens/verification_telephone.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => DataRepository(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The collective saving',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash',
      routes: {
        'login': (context) => const Login(),
        'splash': (context) => const SplashScreen(),
        'telephone': (context) => const Inscription(),
        'verification': (context) => const VerificationTelephone(
              verificationId: "1222",
              telephone: "111",
            ),
        'inscription': (context) => const InscriptionFinal(
              telephone: "111",
              uid: "z",
            ),
      },
    );
  }
}
