import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../AppLandingPage.dart';

class AddNewPassword extends StatefulWidget {
  const AddNewPassword({super.key});

  @override
  State<AddNewPassword> createState() => _AddNewPasswordState();
}

class _AddNewPasswordState extends State<AddNewPassword> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

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
              Text("ADD NEW PASSWORD"),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  padding: EdgeInsets.all(8), // Border width
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(48), // Image radius
                      child:
                          Image.asset('assets/password.jpg', fit: BoxFit.cover),
                    ),
                  ),
                ),

                SizedBox(
                  height: 40,
                ),

                //INPUT FIELD
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Name : ",
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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

                SizedBox(
                  height: 35,
                ),

                TextFormField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Password : ",
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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

                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: FloatingActionButton.extended(
                    onPressed: () async {
                      // Add your onPressed code here!
                      if (_nameController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty) {
                        //For password encryption
                        final plainText = _passwordController.text;
                        final key = encrypt.Key.fromUtf8(
                            '@L%TY4%u#XL<,*|{dgKkje#;Gh1Md;JG');
                        final iv = encrypt.IV.fromLength(16);
                        final encrypter = encrypt.Encrypter(encrypt.AES(key));
                        final encrypted = encrypter.encrypt(plainText, iv: iv);
                        // final decrypted = encrypter.decrypt(encrypted, iv: iv);
                        print(encrypted.base64);

                        // Add the password
                        FirebaseFirestore.instance
                            .collection("password_list")
                            .add({
                          "description": _nameController.text,
                          "password": encrypted.base64,
                          "user": user!.uid,
                        }).then((value) => {
                                  // Show success
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Password added successfully",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    backgroundColor: Colors.green,
                                  )),
                                  _nameController.clear(),
                                  _passwordController.clear(),
                                });
                      } else {
                        // Show error
                        final snack = SnackBar(
                          content: Text(
                            "Please fill all the fields",
                            style: TextStyle(fontSize: 20),
                          ),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      }
                    },
                    label: const Text('Add the password'),
                    icon: const Icon(Icons.thumb_up),
                    backgroundColor: Colors.pink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
