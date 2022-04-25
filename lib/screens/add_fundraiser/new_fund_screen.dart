import 'dart:developer';
import 'dart:io';

import 'package:crowd_application/screens/campaign_detail/proof_preview_widget.dart';
import 'package:crowd_application/utils/file_picker.dart';
import 'package:file_picker/file_picker.dart';
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

  DateTime? lastDate = DateTime.now().add(const Duration(days: 7));
  String dateString = "Select";
  File? bannerImage;
  // _proofs = upload them on document
  final List<Map<String, String>> _proofs = [];
  // _files = Temp files stored before converting them to _proofs
  final List<FilePickerResult> _files = [];

  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    void convertFilesToProofsList() {
      _proofs.clear();
      for (var file in _files) {
        // Upload files to database
        // get url link
        String fileUrl = "File URL here";
        // adding to proofs
        _proofs.add({
          "fileName": file.files.first.name,
          "fileUrl": fileUrl,
        });
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

    Future<void> newFund() async {
      bool isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
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
      convertFilesToProofsList();
      for (var element in _proofs) {
        log(element.toString() + "\n");
      }
      // upload stuff to document
      setState(() {
        _isUploading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text("Raise a new fund"),
      ),
      body: Form(
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
                            Text(DateFormat('dd-MMMM-yyyy').format(lastDate!)),
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
                        if (value!.isEmpty ||
                            value == "" ||
                            value.length <= 5) {
                          return "Please Enter a valid Name.";
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
                        if (amount > 1000000000) {
                          return "Cannot Fund that amount of money.";
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
                  // Proofs
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                        newFund();
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
          )),
    );
  }
}
