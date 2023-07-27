import 'package:flutter/material.dart ';
import 'package:password_vault/Service/Auth_Service.dart';
import 'package:password_vault/pages/Content/AddNewPassword.dart';
import 'package:password_vault/pages/Content/PasswordGenerate.dart';
import 'package:password_vault/pages/Content/PasswordList.dart';

import 'SignUpPage.dart';

class AppLandingPage extends StatefulWidget {
  const AppLandingPage({super.key});

  @override
  State<AppLandingPage> createState() => _AppLandingPageState();
}

class _AppLandingPageState extends State<AppLandingPage> {
  AuthClass authClass = new AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () async {
              authClass.logOut(context);

              //navigate to signIn page
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => SignUpPage()),
                  (route) => false);
            },
            icon: Padding(
              padding: const EdgeInsets.only(top: 2, right: 5),
              child: const Icon(
                Icons.logout_rounded,
                size: 30,
              ),
            ),
          )
        ],
        bottom: PreferredSize(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(left: 22),
                child: Text(
                  "WELCOME!",
                  style: TextStyle(
                      fontSize: 50,
                      color: Color.fromARGB(255, 146, 51, 255),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(40)),
      ),

      //BODY OF THE PAGE
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 63, 63, 63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: Colors.white),
                ),
                //GENERATE PASSWORD BUTTON
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                  child: Text(
                    "GENERATE PASSWORD",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => PasswordGenerate()),
                      (route) => false);
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 63, 63, 63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: Colors.white),
                ),
                //GENERATE PASSWORD BUTTON
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                  child: Text(
                    "VIEW THE PASSWORDS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => PasswordList()),
                      (route) => false);
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 63, 63, 63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: Colors.white),
                ),
                //GENERATE PASSWORD BUTTON
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                  child: Text(
                    "ADD  NEW  PASSWORD",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => AddNewPassword()),
                      (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
