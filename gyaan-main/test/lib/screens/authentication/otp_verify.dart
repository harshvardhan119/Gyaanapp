import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gyaan/controllers/auth_methods.dart';
import 'package:gyaan/screens/welcome.dart';

import '../../utils/utils.dart';

class OtpVerify extends StatefulWidget {
  final String verificationId, email, password, phoneNumber;
  const OtpVerify(
      {super.key,
      required this.verificationId,
      required this.email,
      required this.password,
      required this.phoneNumber});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  bool isLoading = false;
  final otpController = TextEditingController();
  final auth = FirebaseAuth.instance;

  void verifyOtp() async {
    setState(() {
      isLoading = true;
    });
    final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otpController.text);

    try {
      await auth.signInWithCredential(credential);
      String phoneId = await FirebaseAuth.instance.currentUser!.uid;
      String res = await AuthMethods().signUpUser(
          email: widget.email,
          password: widget.password,
          phoneNumber: widget.phoneNumber,
          phoneuid: phoneId);
      if (context.mounted && res == "success") {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, "something went wrong");
      }
    } catch (e) {
      if (context.mounted) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 52, 216, 203),
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Text(
                  "Enter the one time password sent to \n your mobile number",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2,
                      left: 20,
                      right: 20),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    controller: otpController,
                    decoration: InputDecoration(
                      counterStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.password),
                      hintText: "Enter 6 digit Otp",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: const Color.fromARGB(255, 58, 58, 58),
                            width: 2.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.4),
                  child: ElevatedButton(
                    onPressed: () => verifyOtp(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 249, 249, 249),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    ),
                    child: isLoading
                        ? SizedBox(
                            child: const CircularProgressIndicator(
                              color: Color.fromARGB(255, 135, 135, 135),
                            ),
                            height: 20,
                            width: 20,
                          )
                        : Text(
                            "verify otp",
                            style: TextStyle(
                                color: Color.fromARGB(255, 192, 192, 192),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.56,
                ),
                child: Center(
                  child: TextButton(
                    child: Text(
                      "Resend otp",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
