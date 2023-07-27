// import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:password_vault/pages/PhoneAuthPage.dart';
import 'package:password_vault/pages/SignInPage.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../Service/Auth_Service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //for google signIn
  AuthClass authClass = AuthClass();

  bool loader = false;

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
            "Sign Up",
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),

          //INSTEAD OF COPYING LIKE THIS WE CAN USE THE WIDGET FUNCTION
          //for google
          buttonItems("Google", "google-icon"),
          //for phone
          buttonItems("Phone", "phone-icon"),

          SizedBox(
            height: 10,
          ),
          Text(
            "Or",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
          ),

          SizedBox(
            height: 10,
          ),
          //email input;
          InputFormFields("Email", emailController),
          SizedBox(height: 10),
          InputFormFields("Password", passwordController),
          SizedBox(height: 10),
          SignUpButton(),

          SizedBox(
            height: 20,
          ),

          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account?",
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
                      MaterialPageRoute(builder: (builder) => SignInPage()),
                      (route) => false);
                },
                child: Text(
                  "LOGIN",
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
    return InkWell(
      onTap: () {
        if (name == "Google") {
          //function the file
          authClass.googleSignIn(context);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => PhoneAuthPage()),
              (route) => false);
        }
      },
      child: Container(
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

  Widget SignUpButton() {
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
              // ignore: unused_local_variable
              firebase_auth.UserCredential userCred =
                  await auth.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text);

              setState(() {
                loader = false;
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => SignInPage()),
                  (route) => false);
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
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
          ),
        ));
  }
}
