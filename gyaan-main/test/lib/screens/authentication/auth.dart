import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gyaan/screens/authentication/signup.dart';
import 'package:gyaan/screens/welcome.dart';
import '../../utils/utils.dart';

class AUTHSELLER extends StatefulWidget {
  const AUTHSELLER({super.key});

  @override
  State<AUTHSELLER> createState() => _AUTHSELLERState();
}

class _AUTHSELLERState extends State<AUTHSELLER> {
  bool _isLoading = false;
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  void signInFunc() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => WelcomeScreen(),
          ),
          (Route<dynamic> route) => false);
      setState(() {
        _isLoading = false;
      });
      return null;
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
    return Container(
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
                        height: 20,
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
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          signInFunc();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                        ),
                        child: _isLoading == true
                            ? SizedBox(
                                child: const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 91, 91, 91),
                                ),
                                height: 20,
                                width: 20,
                              )
                            : Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 156, 156, 156),
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
                              "Sign up",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupSeller(),
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
    );
  }
}
