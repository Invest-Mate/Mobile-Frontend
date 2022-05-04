import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crowd_application/screens/auth/signup_form.dart';
import 'package:crowd_application/screens/home/home_screen.dart';
import 'package:crowd_application/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Wrapper extends StatelessWidget {
  const Wrapper({
    Key? key,
  }) : super(key: key);
  Future<Map> getUserInfo(String userId) async {
    Map result = {};
    try {
      final uri =
          Uri.parse("https://fundzer.herokuapp.com/api/user/get-user/$userId");
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final http.Response res = await http.get(uri, headers: headers);
      final document = jsonDecode(res.body);
      log(document.toString());
      if (document["status"] == "fail") {
        result = {"status": "userNotExist"};
      } else if (document["status"] == "success") {
        result = {"status": "userExist"};
      }
    } catch (e) {
      result = {"status": "userNotExist"};
    }
    log(result.toString());
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final cUser = FirebaseAuth.instance.currentUser;
    if (cUser == null) {
      return SplashScreen();
    }

    return FutureBuilder(
        future: getUserInfo(cUser.uid),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.data["status"] == "userNotExist") {
            return const SignUpForm();
          }

          return HomeScreen();
        });
  }
}
