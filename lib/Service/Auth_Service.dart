import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:password_vault/pages/AppLandingPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  // Create storage
  final storage = new FlutterSecureStorage();

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        // ignore: unused_local_variable
        try {
          UserCredential result =
              await FirebaseAuth.instance.signInWithCredential(credential);


          //store the signIn token
          // await storeTokenAndData(result);
          //everytime need to login


          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => AppLandingPage()),
              (route) => false);
        } catch (e) {
          final snackBar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        final snackBar = const SnackBar(content: Text("Not able to Sign In"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e);
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    //store the signIn token
    if(userCredential.credential != null)
    {
      await storage.write(
        key: "token", value: userCredential.credential?.token.toString());
      await storage.write(
          key: "userCredential", value: userCredential.toString());
    }
  }

  Future<String?> getToken() async {
    // ignore: unnecessary_null_comparison
    if (storage.read(key: "token") == null) {
      return null;
    }
    return await storage.read(key: "token");
  }

  //for logout

  Future<void> logOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      await storage.delete(key: "token");
    } catch (e) {
      final snack = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
  }

  //FOR PHONE AUTHENTICATION and Sending OTP
  Future<void> verifyPhone(
      String phone, BuildContext context, Function setData) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      // await _auth.signInWithCredential(credential);
      ShowSnackbar(context, "Verification Completed");
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) async {
      ShowSnackbar(context, e.toString());
    };

    PhoneCodeSent codeSent =
        (String verificationID, [int? forceResendingToken]) {
      setData(verificationID);
      ShowSnackbar(context, "Verification Code Sent");
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      ShowSnackbar(context, "Time Out");
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      ShowSnackbar(context, e.toString());
    }
  }

  //for signing in with phone number
  Future<void> SignInPhone(
      String verificationID, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: smsCode);

      UserCredential userCred = await _auth.signInWithCredential(credential);

      // await storeTokenAndData(userCred);
      //everytime need to login

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => AppLandingPage()),
          (route) => false);

      ShowSnackbar(context, "Successfully Signed In");
    } catch (e) {
      ShowSnackbar(context, e.toString());
    }
  }

  void ShowSnackbar(BuildContext context, String text) {
    SnackBar snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
