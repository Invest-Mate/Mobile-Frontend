import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crowd_application/screens/home/home_screen.dart';
import 'package:crowd_application/utils/file_picker.dart';
import 'package:crowd_application/utils/upload_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // userId
  // email
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _aadhar = TextEditingController();
  final TextEditingController _aadress = TextEditingController();
  DateTime? dob = DateTime.now();
  String dateString = "Select";
  File? profilePic;
  bool _isUploading = false;
  Future uploadData(String userId, String email) async {
    bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else if (profilePic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select a Banner.",
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      _isUploading = true;
    });
    try {
      final uri =
          Uri.parse("https://fundzer.herokuapp.com/api/user/create-user");
      final createFundRes = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "aadhar": _aadhar.text.trim(),
          "email": email.trim(),
          "address": _aadress.text.trim(),
          "dob": dob!.toIso8601String(),
          "userId": userId,
          "contact": "9172398229",
          "_id": userId,
          "name": _name.text.trim(),
        }),
      );
      final response = jsonDecode(createFundRes.body);
      log(response.toString());
      // uploading image files through patch
      Timer(Duration(seconds: 5), () {
        final file = FileUpload();

        file.updateProfile(
          profileImage: profilePic!,
          id: userId,
          url: "https://fundzer.herokuapp.com/api/user/update-user",
        );
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    String email = FirebaseAuth.instance.currentUser!.email!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: <Widget>[
                // show image
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: profilePic != null
                          ? Colors.white
                          : Colors.blueGrey[100],
                    ),
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: profilePic != null
                        ? Image.file(
                            profilePic!,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Text(
                              "Profile Picture",
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.2,
                            ),
                          ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    MyFilePicker myFilePicker = MyFilePicker();
                    File? pickedFile =
                        await myFilePicker.showPicker(FileType.image);
                    if (pickedFile != null) {
                      setState(() {
                        profilePic = pickedFile;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: const Text("Select Profile Image"),
                ),
                // date of birth
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      const Text('D.O.B: '),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(DateFormat('dd-MMMM-yyyy').format(dob!)),
                          IconButton(
                            onPressed: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setState(() {
                                  dob = date;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.calendar_month,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                //  name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value == "") {
                        return "Please Enter a valid Name.";
                      } else if (value.length <= 10) {
                        return "Enter longer name";
                      } else if (value.length >= 40) {
                        return "Enter short name";
                      }
                      return null;
                    },
                    controller: _name,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Colors.blueGrey,
                      ),
                      label: const Text("Full Name"),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blueGrey[200]!,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2.5,
                          color: Colors.red,
                          // color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2.5,
                          color: Colors.red,
                          // color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2.5,
                          color: Color.fromRGBO(254, 161, 21, 1),
                          // color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                // address
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value == "") {
                        return "Please Enter a valid Description.";
                      }
                      return null;
                    },
                    controller: _aadress,
                    maxLines: 2,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Colors.blueGrey,
                      ),
                      label: const Text("Address"),
                      // floatingLabelAlignment: FloatingLabelAlignment.start,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blueGrey[200]!,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2.5,
                          color: Colors.red,
                          // color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2.5,
                          color: Colors.red,
                          // color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2.5,
                          color: Color.fromRGBO(254, 161, 21, 1),
                          // color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                // AADHAR
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty || value == "") {
                        return "Please Enter a valid Name.";
                      } else if (value.length != 12) {
                        return "Enter Correct Aadhar Number";
                      }
                      return null;
                    },
                    controller: _aadhar,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Colors.blueGrey,
                      ),
                      label: const Text("Aadhar Number"),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blueGrey[200]!,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2.5,
                          color: Colors.red,
                          // color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2.5,
                          color: Colors.red,
                          // color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2.5,
                          color: Color.fromRGBO(254, 161, 21, 1),
                          // color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                // upload button
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.maxFinite, 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        primary: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        )),
                    onPressed: () {
                      uploadData(uId, email);
                    },
                    child: _isUploading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text('Sign UP'),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
