import 'package:flutter/material.dart';

import '../Models/user.dart';

Color primaryColor = const Color(0xFF0069FE);
Color successColor = const Color(0xff368983);

Color secondaryColor = const Color(0xFF0069FE).withOpacity(0.1);
Color whiteColor = Colors.white;
Color blackColor = Colors.black;
Color greyColor = const Color.fromARGB(255, 245, 242, 242);
//Pour stocker les infos de l'utilisateurs connecté
late UserModel userInstance;
late String idUser;
late String nomUser;
late String telephoneUser;
