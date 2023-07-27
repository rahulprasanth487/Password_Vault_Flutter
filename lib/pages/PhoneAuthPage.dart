import 'dart:async';

import "package:flutter/material.dart";
import 'package:otp_text_field/otp_field_style.dart';
import 'package:password_vault/Service/Auth_Service.dart';
import "package:password_vault/pages/SignUpPage.dart";
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  int start = 30;
  bool waitSend = false;
  String buttonName = "Send";
  TextEditingController phoneController = TextEditingController();
  AuthClass authClass = AuthClass();
  String smsOTP = "";
  String verificationIdFinal = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 60, 60),
        //TITLE OF THE PAGE
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => SignUpPage()),
                      (route) => false);
                },
                icon: Icon(Icons.arrow_back),
              ),
              SizedBox(
                width: 90,
              ),
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 23, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),

      //NOW BODY OF THE PAGE
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              textField(),
              SizedBox(
                height: 35,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 34,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "  Enter the 6-Digit OTP  ",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              otp(),
              SizedBox(
                height: 40,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "Send OTP again in ",
                  style: TextStyle(fontSize: 16, color: Colors.yellowAccent),
                ),
                TextSpan(
                  text: "00.$start",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                TextSpan(
                  text: " sec",
                  style: TextStyle(fontSize: 16, color: Colors.yellowAccent),
                ),
              ])),
              SizedBox(
                height: 150,
              ),
              InkWell(

                onTap: () {
                  authClass.SignInPhone(
                      verificationIdFinal, smsOTP, context);

                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xffff9601),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //OTP INPUT TEXT FIELD

  Widget textField() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xff1d1d1d),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          controller: phoneController,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter the phone number ",
            hintStyle: TextStyle(color: Colors.white54, fontSize: 17),
            contentPadding: EdgeInsets.symmetric(vertical: 19, horizontal: 15),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(vertical: 19, horizontal: 15),
              child: Text(
                "(+91)",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
            suffixIcon: InkWell(
              onTap: waitSend
                  ? null
                  : () async {
                      setState(() {
                        start = 30;
                        waitSend = true;
                        buttonName = "Resend";
                      });

                      await authClass.verifyPhone(
                          "+91 ${phoneController.text}", context, setData);
                    },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 19, horizontal: 15),
                child: Text(
                  buttonName,
                  style: TextStyle(
                      color: waitSend ? Colors.white54 : Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget otp() {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 34,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: Color(0xff1d1d1d),
        borderColor: Colors.white,
      ),
      fieldWidth: 48,
      style: TextStyle(
        fontSize: 17,
        color: Colors.white,
      ),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          smsOTP = pin;
        });
      },
    );
  }

  //timer
  void timer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          setState(() {
            start = 30;
            waitSend = false;
            buttonName = "Send";
          });
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  void setData(verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    timer();
  }
}
