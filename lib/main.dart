import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:password_vault/Service/Auth_Service.dart';
import 'package:password_vault/pages/AppLandingPage.dart';
import 'package:password_vault/pages/AppWelcome.dart';
import 'package:password_vault/pages/SignUpPage.dart'; //to use firebase authentication
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  //to setup firebase
  WidgetsFlutterBinding.ensureInitialized(); //to bind the app widgets

  //from firebase project setttings
  //to solve the error in connecting wiht firebase for authentication
  String apiKey = "AIzaSyCj93FZVx_AOc1Y1ihv4txskrGvSeiyEf8";
  String appId = "1:333510818712:android:ac05bb70c810e27f12c9ed";
  String messagingSenderId = "333510818712";
  String projectId = "password-vault-app";

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId)); //to initialize the firebase app

  runApp(const MyApp());
}




class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthClass authClass = AuthClass();
  // Widget currentPage = SignUpPage();
  Widget currentPage = const WelcomePage();

  final Storage = new FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();

    if (token != null) {
      setState(() {
        currentPage = AppLandingPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: currentPage,
    );
  }
}
