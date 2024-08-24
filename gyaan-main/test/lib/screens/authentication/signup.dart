import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gyaan/screens/authentication/auth.dart';
import 'package:gyaan/screens/authentication/otp_verify.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../utils/utils.dart';

class SignupSeller extends StatefulWidget {
  const SignupSeller({super.key});

  @override
  State<SignupSeller> createState() => _SignupSellerState();
}

class _SignupSellerState extends State<SignupSeller> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  String phoneNumber = "";
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (_) => {},
        verificationFailed: (e) => {
          if (context.mounted) {showSnackBar(context, e.toString())},
        },
        codeSent: (String verificationId, int? token) {
          setState(() {
            _isLoading = false;
          });
          if (context.mounted) {
            showSnackBar(context, "Otp Send!");
          }
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerify(
                  verificationId: verificationId,
                  email: _emailController.text,
                  password: _passwordController.text,
                  phoneNumber: phoneNumber,
                ),
              ),
            );
          }
        },
        codeAutoRetrievalTimeout: (e) => {
          if (context.mounted) {showSnackBar(context, e.toString())},
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color.fromARGB(255, 166, 218, 236),
          body: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 90,
                  left: 50,
                  height: 50,
                  width: 240,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        ImageIcon(
                          AssetImage("assets/images/logo_bg.png"),
                          color: Colors.white,
                          size: 64,
                        ),
                        Text(
                          'Gyaan Saarthi',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 26,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3,
                        left: 35,
                        right: 35),
                    child: Column(
                      children: [
                        TextField(
                          cursorColor: const Color.fromARGB(255, 58, 58, 58),
                          controller: _emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: const Color.fromARGB(255, 58, 58, 58),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          cursorColor: const Color.fromARGB(255, 58, 58, 58),
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: const Color.fromARGB(255, 58, 58, 58),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        IntlPhoneField(
                          cursorColor: const Color.fromARGB(255, 58, 58, 58),
                          decoration: InputDecoration(
                            hintText: "Phone Number",
                            counterStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: const Color.fromARGB(255, 58, 58, 58),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          initialCountryCode: 'IN',
                          onChanged: (phone) {
                            setState(() {
                              phoneNumber = phone.completeNumber;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () => {
                            if (_emailController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty &&
                                phoneNumber.length != 0)
                              {signUpUser()}
                            else
                              {showSnackBar(context, "credentials required")}
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // <-- Radius
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  child: const CircularProgressIndicator(
                                    color: Color.fromARGB(255, 91, 91, 91),
                                  ),
                                  height: 20,
                                  width: 20,
                                )
                              : Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 151, 151, 151),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: Center(
                            child: GestureDetector(
                              child: Text(
                                "sign In",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AUTHSELLER(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
