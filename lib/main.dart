import 'package:crystal_classifier/View/Screens/AllWorkspacesUI.dart';
import 'package:crystal_classifier/View/Screens/LoginUI.dart';
import 'package:crystal_classifier/View/Screens/NoWorkspaceUI.dart';
import 'package:crystal_classifier/View/Screens/SignupUI.dart';
import 'package:crystal_classifier/View/Screens/WorkspaceUI.dart';
import 'package:crystal_classifier/View/Utils/Colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Controller/UserController.dart';
import 'View/Screens/Login_Signup_OptionUI.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    title: 'Crystal Classifier',
    debugShowCheckedModeBanner: false,
    home:
        LoginSignupOption(), //WorkspaceUI(),//AllWorkSpacesUI(), // NoWorkSpaceUI(),//LoginSignupOption(),
    theme: ThemeData(
      fontFamily: 'Circe',
      textSelectionColor: mosqueColor0,
      textSelectionHandleColor: mosqueColor1,
    ),
  ));
}

//   class View extends AppView {
//     factory View() => _this ??= View._();
//     View._()
//       : super(
//     title: 'Flutter Demo',
//     home: HomePage(),
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//     ),
//   );
//   static View _this;

// }
