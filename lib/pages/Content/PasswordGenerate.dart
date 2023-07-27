import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_vault/pages/AppLandingPage.dart';

class PasswordGenerate extends StatefulWidget {
  const PasswordGenerate({super.key});

  @override
  State<PasswordGenerate> createState() => _PasswordGenerateState();
}

class _PasswordGenerateState extends State<PasswordGenerate> {
  TextEditingController passwordLengthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        title: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => AppLandingPage()),
                  (route) => false);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 90,
            ),
            Text(
              "Password Generator",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xff1d1d1d),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: passwordLengthController,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter the length of password ",
                            hintStyle:
                                TextStyle(color: Colors.white54, fontSize: 17),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 19, horizontal: 18),
                            suffixIcon: InkWell(
                              onTap: () {
                                if (passwordLengthController.text.isEmpty) {
                                  // ignore: non_constant_identifier_names
                                  final snack = SnackBar(
                                    content: Text("Enter a valid length"),
                                    backgroundColor: Colors.red,
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snack);
                                } else {
                                  var len =
                                      int.parse(passwordLengthController.text);
                                  String GenPass = generateRandomString(len);

                                  print(GenPass);

                                  _dialogBuilder(context, GenPass);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                child: Text(
                                  "GENERATE",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //to generate the password
  String generateRandomString(int lengthOfString) {
    final random = Random();
    const allChars =
        'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL1234567890#@&*!~';
    // below statement will generate a random string of length using the characters
    // and length provided to it
    final randomString = List.generate(lengthOfString,
        (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString; // return the generated string
  }

  // PASSWORD SHOW
  Future<void> _dialogBuilder(BuildContext context, String password) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 28, 28, 28),
          title: const Text(
            'Generated Password',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          content: Text(
            "${password}",
            style: TextStyle(
              fontSize: 30,
              color: Color.fromARGB(255, 24, 255, 12),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  backgroundColor: Color.fromARGB(255, 49, 49, 49)),
              child: const Text(
                'COPY',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
              onPressed: () {
                // Navigator.of(context).pop();

                //for copying the password to clipboard
                Clipboard.setData(ClipboardData(text: password));

                final snack = SnackBar(
                  content: Text(
                    "Copied to Clipboard",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  backgroundColor: Colors.white,
                );
                ScaffoldMessenger.of(context).showSnackBar(snack);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  backgroundColor: Color.fromARGB(255, 49, 49, 49)),
              child: const Text(
                'CLOSE',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
