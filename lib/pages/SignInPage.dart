// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:password_vault/pages/AppLandingPage.dart';
import 'package:password_vault/pages/SignUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loader = false;

  //for google signIn token
  final Storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Sign In",
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),

          //INSTEAD OF COPYING LIKE THIS WE CAN USE THE WIDGET FUNCTION
          //for google
          // buttonItems("Google", "google-icon"),
          // //for phone
          // buttonItems("Phone", "phone-icon"),

          SizedBox(
            height: 15,
          ),
          //email input;
          InputFormFields("Email", emailController),
          SizedBox(height: 10),
          InputFormFields("Password", passwordController),
          SizedBox(height: 10),
          SignInButton(),

          SizedBox(
            height: 20,
          ),

          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontSize: 15),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => SignUpPage()),
                      (route) => false);
                },
                child: Text(
                  "Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20),
                ),
              ),
            ],
          ))
        ]),
      ),
    ));
  }

  Widget buttonItems(String name, String icon_name) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width - 60,
      alignment: Alignment.center,
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(width: 1, color: Colors.white),
        ),
        child: Row(
          //align the icon and field in the same row
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            SvgPicture.asset(
              "assets/$icon_name.svg",
              height: 30,
              width: 30,
            ),
            SizedBox(
              width: 25,
              height: 45,
            ),
            Text(
              "Continue with $name",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget InputFormFields(String type, TextEditingController controller) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width - 60,
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        obscureText: (type == "Password") ? true : false,
        decoration: InputDecoration(
          labelText: type,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 1.5,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 1,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget SignInButton() {
    return InkWell(
        onTap: () async {
          if (emailController.text.isEmpty) {
            final snackBar = SnackBar(
              content: Text("Please enter the email"),
              backgroundColor: Colors.red,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (passwordController.text.isEmpty) {
            final snackBar = SnackBar(
              content: Text("Please enter the password"),
              backgroundColor: Colors.red,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            setState(() {
              loader = true;
            });
            print("Email: ${emailController.text}");
            print("Password: ${passwordController.text}");

            try {
              firebase_auth.UserCredential userCredential =
                  await auth.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text);

              setState(() {
                loader = false;
              });

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const AppLandingPage()),
                  (route) => false);

              print(userCredential.credential?.token.toString());

              await Storage.write(
                  key: "token",
                  value: userCredential.credential?.token.toString());
            } catch (e) {
              final snackBar = SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              setState(() {
                loader = false;
              });
            }
          }
        },
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width - 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 7, 112, 241),
              Color.fromARGB(255, 7, 158, 245),
              Color.fromARGB(255, 0, 186, 248),
            ]),
          ),
          child: Center(
            child: loader
                ? CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
          ),
        ));
  }
}
