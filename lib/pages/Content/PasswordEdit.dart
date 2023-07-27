import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class PasswordEdit extends StatelessWidget {
  final String id;
  final String description;
  const PasswordEdit({super.key, required this.id, required this.description});

  @override
  Widget build(BuildContext context) {
    TextEditingController _descriptionController =
        TextEditingController(text: description);
    TextEditingController _newPassController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Edit Password')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8), // Border width
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(40), // Image radius
                    child:
                        Image.asset('assets/editIcon.jpg', fit: BoxFit.cover),
                  ),
                ),
              ),

              SizedBox(height: 40),

              //INPUT FIELDr
              TextField(
                controller: _descriptionController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _newPassController,
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                // onPressed: isLoading ? null : _login,
                onPressed: () {
                  if (_descriptionController.text.isNotEmpty &&
                      _newPassController.text.isNotEmpty) {
                    // _login();
                    final plainText = _newPassController.text;
                    final key = encrypt.Key.fromUtf8(
                        '@L%TY4%u#XL<,*|{dgKkje#;Gh1Md;JG');
                    final iv = encrypt.IV.fromLength(16);
                    final encrypter = encrypt.Encrypter(encrypt.AES(key));
                    final encrypted = encrypter.encrypt(plainText, iv: iv);
                    // final decrypted = encrypter.decrypt(encrypted, iv: iv);
                    print(encrypted.base64);
                    FirebaseFirestore.instance
                        .collection("password_list")
                        .doc(id)
                        .update({
                      "description": _descriptionController.text,
                      "password": encrypted.base64,
                    });

                    try {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Password Updated Successfully',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      ));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          e.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Please fill all the fields',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                child: Text('UPDATE PASSWORD'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
