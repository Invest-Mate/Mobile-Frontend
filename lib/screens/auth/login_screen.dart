import 'dart:developer';

import 'package:crowd_application/screens/home/home_screen.dart';
import 'package:crowd_application/services/5.auth_services.dart';
import 'package:crowd_application/widgets/wrapper.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  bool _isLoading = false;
  InputDecoration? _decoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    //define functions below
    tryLogin() async {
      bool isValid = _formkey.currentState!.validate();
      if (!isValid) {
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const Wrapper()),
        );
      } catch (e) {
        log(e.toString());
      }
      setState(() {
        _isLoading = false;
      });
    }

    trySignupWithGoogle() async {
      setState(() {
        _isLoading = true;
      });
      try {
        await AuthService.firebase().signInWithGoogle();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const Wrapper()),
        );
      } on FirebaseAuthException catch (e) {
        log(e.message.toString());
      } on PlatformException catch (e) {
        log(e.message.toString());
      } catch (e) {}
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: deviceWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: deviceHeight * 0.3,
                    // width: deviceWidth * 0.8,
                    child: const Image(
                      image: AssetImage('assets/images/login.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: deviceWidth * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 10),
                      child: FittedBox(
                        child: Text(
                          'Login to your account.',
                          style: TextStyle(color: Colors.blueGrey[600]),
                        ),
                      ),
                    ),
                  ),
                  // phone number
                  Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DottedBorder(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            radius: const Radius.circular(0),
                            borderType: BorderType.RRect,
                            dashPattern: const [5, 3],
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _email,
                              decoration: _decoration('Email Address'),
                              textAlign: TextAlign.center,
                              validator: (text) {
                                if (text!.isEmpty || text == '') {
                                  return 'Please enter your email.';
                                }

                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DottedBorder(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            radius: const Radius.circular(0),
                            borderType: BorderType.RRect,
                            dashPattern: const [5, 3],
                            child: TextFormField(
                              obscureText: true,
                              obscuringCharacter: '✦',
                              keyboardType: TextInputType.emailAddress,
                              controller: _password,
                              decoration: _decoration('Password'),
                              textAlign: TextAlign.center,
                              validator: (text) {
                                if (text!.isEmpty || text == '') {
                                  return 'Please enter your password.';
                                }
                                if (text.length < 6) {
                                  return 'Please enter a longer password';
                                }

                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // signin button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(255, 161, 20, 1),
                        minimumSize:
                            const Size(double.maxFinite, double.minPositive),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        tryLogin();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          _isLoading ? 'Loading' : 'Sign in',
                          style: const TextStyle(
                            color: Colors.white,
                            // color: Colors.deepOrange,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //OR
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: deviceWidth * 0.35,
                        color: Colors.blueGrey[600],
                        height: 2,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('OR'),
                      ),
                      Container(
                        width: deviceWidth * 0.35,
                        color: Colors.blueGrey[600],
                        height: 2,
                      )
                    ],
                  ),
                  //submit with google
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        primary: Colors.grey[100],
                        elevation: 0,
                      ),
                      onPressed: () {
                        trySignupWithGoogle();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Image(
                            image: AssetImage(
                                'assets/images/google-logo-9825.png'),
                            width: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Sign up with Google',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Dont have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Create!',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 161, 20, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
