import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crowd_application/screens/add_fundraiser/upload_fund.dart';
import 'package:crowd_application/screens/auth/signup_screen.dart';
import 'package:crowd_application/screens/home/home_screen.dart';
import 'package:crowd_application/utils/file_picker.dart';
import 'package:crowd_application/utils/upload_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? profilePic;
  final String defaultImg =
      'https://media.istockphoto.com/vectors/user-avatar-profile-icon-black-vector-illustration-vector-id1209654046?k=20&m=1209654046&s=612x612&w=0&h=Atw7VdjWG8KgyST8AXXJdmBkzn0lvgqyWod9vTb2XoE=';

  getUser(String userId) async {
    Map result = {};
    try {
      final uri =
          Uri.parse("https://fundzer.herokuapp.com/api/user/get-user/$userId");
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final http.Response res = await http.get(uri, headers: headers);
      final document = jsonDecode(res.body);

      result = {"status": "success", "data": document["data"]};
    } catch (e) {
      result = {
        "status": "fail",
      };
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        FirebaseAuth.instance.currentUser != null ? true : false;
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder(
          future: !isLoggedIn
              ? null
              : getUser(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            String profileImgUrl = "";
            String userName = "username";
            String email = "email";
            String dob = "Date of Birth";
            String aadhar = "Aadhar Number";
            String aadress = "Address";
            String contact = "Contact Number";
            if (isLoggedIn) {
              if (snapshot.data["status"] != "success") {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    foregroundColor: Colors.black,
                  ),
                  body: const Center(
                    child: Text("Failed to load data."),
                  ),
                );
              }
              final userData = snapshot.data["data"];
              log(userData.toString());
              if (userData != null) {
                profileImgUrl = userData["photo"];
                userName = userData["name"];
                email = userData["email"];
                dob = DateFormat("dd-MMMM-yyyy").format(
                  DateTime.parse(userData["dob"]),
                );
                aadhar = userData["aadhar"];
                aadress = userData["address"];
                contact = userData["contact"];
              }
            }

            return SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CircleAvatar(
                            radius: deviceWidth * 0.2,
                            backgroundImage: NetworkImage(
                              isLoggedIn ? profileImgUrl : defaultImg,
                            ),
                          ),
                        ),
                        if (!isLoggedIn)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            style:
                                ElevatedButton.styleFrom(primary: Colors.black),
                            child: const Text('Sign Up'),
                          ),
                        if (isLoggedIn)
                          Container(
                            constraints:
                                BoxConstraints(maxWidth: deviceWidth * 0.4),
                            child: FittedBox(
                              child: Text(
                                userName.toUpperCase(),
                                textScaleFactor: 1.3,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        if (isLoggedIn)
                          Container(
                            constraints:
                                BoxConstraints(maxWidth: deviceWidth * 0.8),
                            child: FittedBox(
                              child: Text(
                                email,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Heading(text: 'Details'),

                        // const Heading(text: 'Contact'),
                        CustomListTile(
                          title: contact,
                          leading: const Icon(
                            Icons.phone,
                          ),
                        ),
                        // const Heading(text: 'D.O.B'),
                        CustomListTile(
                          title: dob,
                          leading: const Icon(
                            Icons.calendar_month,
                          ),
                        ),
                        // const Heading(text: 'Aadhar Number'),
                        CustomListTile(
                          title: aadhar,
                          leading: const ImageIcon(
                              AssetImage('assets/images/aadhar.png')),
                        ),
                        // const Heading(text: 'Address'),
                        CustomListTile(
                          title: aadress,
                          leading: const Icon(
                            Icons.pin_drop_rounded,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    this.title = '',
    required this.leading,
    // ignore: avoid_init_to_null
    this.onTap = null,
  }) : super(key: key);
  final String title;

  final Widget leading;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0,
        ),
        minLeadingWidth: 20,
        title: Text(
          title,
          textScaleFactor: 1,
          style: const TextStyle(
            // fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: leading,
        ),
        trailing: IconButton(
          onPressed: onTap,
          icon: const Icon(
            CupertinoIcons.right_chevron,
          ),
        ),
      ),
    );
  }
}

class Heading extends StatelessWidget {
  const Heading({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.blueGrey,
      ),
    );
  }
}
