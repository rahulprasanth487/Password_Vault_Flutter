import 'package:flutter/material.dart';
import 'package:password_vault/main.dart';
import 'package:password_vault/pages/SignUpPage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Image.network(
          "https://img.freepik.com/free-vector/cyber-security-concept_23-2148532223.jpg?size=626&ext=jpg",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Column(children: <Widget>[
            const Text('Align Button to the Bottom in Flutter'),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 0, 149, 255)),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (builder) => SignUpPage()),
                              (route) => false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: const Text(
                            'GET STARTED!!',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        ))))
          ]),
        ),
      ],
    ));
  }
}
