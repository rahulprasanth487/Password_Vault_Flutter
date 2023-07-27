import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_vault/pages/Content/AddNewPassword.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../AppLandingPage.dart';
import 'PasswordEdit.dart';

class PasswordList extends StatefulWidget {
  const PasswordList({super.key});

  @override
  State<PasswordList> createState() => _PasswordListState();
}

class _PasswordListState extends State<PasswordList> {
  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
      .collection('password_list')
      .where("user", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  String decryptedPass = "";

  void _dialogPassword(BuildContext context, String encryptedPass, String id,String description) {
    var password = encryptedPass;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Encrypted Password : ${password}",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 9, 9),
                  fontWeight: FontWeight.bold,
                )),
            actions: [
              CupertinoDialogAction(
                  onPressed: () {
                    final key = encrypt.Key.fromUtf8(
                        '@L%TY4%u#XL<,*|{dgKkje#;Gh1Md;JG');
                    final iv = encrypt.IV.fromLength(16);
                    final encrypter = encrypt.Encrypter(encrypt.AES(key));
                    final encrypted = encrypt.Encrypted.fromBase64(password);
                    final decrypted = encrypter.decrypt(encrypted, iv: iv);
                    setState(() {
                      decryptedPass = decrypted;
                    });

                    Clipboard.setData(ClipboardData(text: decryptedPass));
                    Navigator.of(context).pop();
                    print(decrypted);
                  },
                  child: Text("DECRIPT")),

              //for EDITING
              CupertinoDialogAction(
                  onPressed: () {
                    print(id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => PasswordEdit(
                                  id: id,
                                  description: description,
                                )));
                  },
                  child: Text("EDIT")),
            ],
            content: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Decrypted Password will be copied to the clipboard",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),

                  Text(
                    decryptedPass,
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  // Text(decryptedPass),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => AppLandingPage()),
                        (route) => false);
                  },
                  icon: Icon(Icons.arrow_back)),
              SizedBox(
                width: 56,
              ),
              Text("STORED PASSWORDS"),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => AddNewPassword()),
              (route) => false);
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      color: Colors.white,
                      child: ExpansionTile(
                        title: Text(
                          (index + 1).toString() + ". " + data["description"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ), //header title
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 220, 220, 220),
                            padding: EdgeInsets.all(20),
                            width: double.infinity,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //for open edit and decrypt window
                                  OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      primary: Colors.white,
                                      backgroundColor: Colors.green,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                    onPressed: () {
                                      // Respond to button press
                                      _dialogPassword(context, data["password"],
                                          snapshot.data!.docs[index].id,data["description"]);
                                    },
                                    icon: Icon(Icons.add, size: 18),
                                    label: Text("OPEN"),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),

                                  //for delete
                                  OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      primary: Colors.white,
                                      backgroundColor: Colors.red,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                    ),
                                    onPressed: () {
                                      // Respond to button press for delete
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('password_list')
                                            .doc(snapshot.data!.docs[index].id)
                                            .delete()
                                            .then((value) => {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Password Deleted Successfully"),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ))
                                                });
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(e.toString()),
                                        ));
                                      }
                                    },
                                    icon: Icon(Icons.delete, size: 18),
                                    label: Text("DELETE"),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
