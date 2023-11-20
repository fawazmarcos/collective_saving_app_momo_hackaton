import 'package:epargne_collective/ui/screens/nav_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:epargne_collective/utils/constant.dart';

import '../../repositories/data_repository.dart';

class LoadingAfterLogin extends StatefulWidget {
  const LoadingAfterLogin({super.key});

  @override
  State<LoadingAfterLogin> createState() => _LoadingAfterLoginState();
}

class _LoadingAfterLoginState extends State<LoadingAfterLogin> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    try {
      final dataProvider = Provider.of<DataRepository>(context, listen: false);
      await dataProvider.initData();
      if (mounted) {
        setState(() {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Bottom();
          }));
        });
      }
    } catch (e) {
      print("Erreur : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitDoubleBounce(
            color: primaryColor,
            size: 40,
          ),
        ],
      ),
    );
  }
}
