import 'dart:io';

import 'package:crowd_application/screens/add_fundraiser/upload_fund.dart';
import 'package:crowd_application/screens/campaign_detail/proof_preview_widget.dart';
import 'package:crowd_application/utils/file_picker.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewFundScreen extends StatefulWidget {
  const NewFundScreen({Key? key}) : super(key: key);

  @override
  State<NewFundScreen> createState() => _NewFundScreenState();
}

class _NewFundScreenState extends State<NewFundScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _money = TextEditingController();
  final TextEditingController _description = TextEditingController();

  DateTime? lastDate = DateTime.now().add(const Duration(days: 7));
  String dateString = "Select";
  String categoryStr = "Others";
  File? bannerImage;
  // _proofs = upload them on document
  final List<File> _proofs = [];
  // _files = Temp files stored before converting them to _proofs
  final List<FilePickerResult> _files = [];

  bool _isUploading = false;
  List<DropdownMenuItem<String>> dropdownItems = <String>[
    'Animal',
    'War',
    'Scientific',
    'Education',
    'Environmental',
    'Financial',
    'Poverty',
    'Health',
    'Disease',
    'Others'
  ].map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  @override
  Widget build(BuildContext context) {
    void convertFilesToProofsList() {
      _proofs.clear();
      for (var file in _files) {
        // adding to proofs
        _proofs.add(File(file.files.first.path!));
      }
    }

    void addFileAsProofs() async {
      MyFilePicker _myPicker = MyFilePicker();
      FilePickerResult? file = await _myPicker.pickFileForProof();

      if (file != null) {
        setState(() {
          _files.add(file);
        });
      }
    }

    Future<void> newFund(String cUser) async {
      bool isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      } else if (categoryStr == "Select Category") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please select a category",
              textAlign: TextAlign.center,
              textScaleFactor: 1,
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else if (bannerImage == null) {
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
      if (_files.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please Upload some valid proof"),
          ),
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      // upload stuff to document
      convertFilesToProofsList();
      final fund = UploadFund();
      bool result = await fund.createNewFund(
        lastdate: lastDate!,
        title: _name.text.trim(),
        userId: cUser,
        amount: double.parse(_money.text.trim()),
        category: categoryStr,
        description: _description.text,
        proofs: _proofs,
        bannerImage: bannerImage!,
      );

      //reset
      setState(() {
        _isUploading = false;
      });

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Fund Created Successfully",
              textAlign: TextAlign.center,
              textScaleFactor: 1.5,
            ),
            backgroundColor: Color.fromRGBO(254, 161, 21, 1),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Failed to Created Fund. Try again.",
              textAlign: TextAlign.center,
              textScaleFactor: 1.5,
            ),
            backgroundColor: Color.fromRGBO(254, 161, 21, 1),
          ),
        );
      }
    }

    final cUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text("Raise a new fund"),
      ),
      body: cUser != null
          ? Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: <Widget>[
                      // show image
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: bannerImage != null
                                ? Colors.white
                                : Colors.blueGrey[100],
                          ),
                          height: 170,
                          width: 170 * 16 / 9, // 16/9 is ratio
                          child: bannerImage != null
                              ? Image.file(
                                  bannerImage!,
                                  fit: BoxFit.cover,
                                )
                              : const Center(
                                  child: Text(
                                    "Please Select a Banner",
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
                              bannerImage = pickedFile;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        child: const Text("Select Banner Image"),
                      ),
                      // date
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            const Text('Last Date: '),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(DateFormat('dd-MMMM-yyyy')
                                    .format(lastDate!)),
                                IconButton(
                                  onPressed: () async {
                                    DateTime? date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now()
                                          .add(const Duration(days: 30)),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(
                                        const Duration(days: 365),
                                      ),
                                    );
                                    if (date != null) {
                                      setState(() {
                                        lastDate = date;
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
                      // fundraiser name
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
                            label: const Text("Fundraiser name"),
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
                      // amount needed
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _money,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter a Amount.";
                            }
                            double amount = double.parse(value);
                            if (amount < 1000) {
                              return "Cannot Fund for less than Rs 1000.";
                            }

                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
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
                            prefix: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text("Rs")),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            labelStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            floatingLabelStyle: const TextStyle(
                              color: Colors.blueGrey,
                            ),
                            label: const Text("Select Amount"),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.blueGrey[200]!,
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
                      // Category
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Category :",
                              textScaleFactor: 1.5,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            DropdownButton<String>(
                              value: categoryStr,
                              menuMaxHeight: 400,
                              dropdownColor: Colors.blueGrey[50],
                              // focusColor: Colors.amber,
                              elevation: 0,
                              // icon: Icon(Icons.arrow_drop_down),

                              items: dropdownItems,
                              onChanged: (val) {
                                setState(() {
                                  categoryStr = val!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      // description
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty || value == "") {
                              return "Please Enter a valid Description.";
                            }
                            return null;
                          },
                          controller: _description,
                          maxLines: 3,
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
                            label: const Text("Description"),
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
                      // Proofs
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Proofs",
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.5,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                addFileAsProofs();
                              },
                              icon: const Icon(Icons.add),
                            )
                          ],
                        ),
                      ),
                      _files.isNotEmpty
                          ? SizedBox(
                              height: 100,
                              width: double.maxFinite,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _files.length,
                                itemBuilder: (context, i) => ProofPreview(
                                  fileName: _files[i].files.first.name,
                                  fileUrl: _files[i].files.first.path!,
                                  isLocalFile: true,
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 100,
                              child: Center(
                                child: Text("No proofs Attached"),
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
                            newFund(cUser.uid);
                          },
                          child: _isUploading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Raise Fund'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: Text("Please Login or Signup first."),
            ),
    );
  }
}
