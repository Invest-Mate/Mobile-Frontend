import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crowd_application/widgets/fund_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<Map> searchFund(String title) async {
    Map result = {};
    try {
      final uri = Uri.parse(
          "https://fundzer.herokuapp.com/api/fund/search?title=$title");
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final http.Response res = await http.get(uri, headers: headers);

      final document = jsonDecode(res.body);
      result = {
        "status": "success",
        "data": document["data"],
      };
    } catch (e) {
      result = {
        "status": "fail",
      };
    }
    log(result.toString());
    return result;
  }

  final TextEditingController search = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSearched = false;
  Future trySearch() async {
    bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      isSearched = true;
    });
    searchFund(search.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Sea',
              style: TextStyle(
                color: Color.fromRGBO(254, 161, 21, 1),
              ),
            ),
            // SizedBox(
            //   width: 10,
            // ),
            Text(
              'rch',
              style: TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8.0, left: 20, right: 20),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                validator: (value) {
                  if (value!.isEmpty || value == "") {
                    return "Enter Fund Name";
                  }
                },
                controller: search,
                decoration: InputDecoration(
                  suffix: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        trySearch();
                      },
                      icon: const Icon(
                        Icons.search,
                      )),
                  contentPadding:
                      const EdgeInsets.only(left: 10, right: 5, bottom: 10),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  floatingLabelStyle: const TextStyle(
                    color: Colors.blueGrey,
                  ),
                  hintText: "Name of Fund",
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
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Text(
                  "Results",
                  textScaleFactor: 1.5,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          if (isSearched)
            FutureBuilder(
              future: searchFund(search.text.trim()),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200,
                    width: double.maxFinite,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.data["status"] != "success") {
                  return const SizedBox(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: Center(
                      child: Text(
                        "No funds for \nthat category found..",
                        textScaleFactor: 1.2,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
                List funds = snapshot.data["data"];
                if (funds.isEmpty) {
                  return const SizedBox(
                    height: 300,
                    width: double.maxFinite,
                    child: Center(
                      child: Text(
                        "No funds found..",
                        textScaleFactor: 1.2,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(),
                    width: double.maxFinite,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: funds.length,
                      itemBuilder: (context, i) {
                        int rAmount = funds[i]['receivedAmount'];
                        int tAmount = funds[i]['projectedAmount'];
                        String imageUrl = funds[i]['imageCover'];
                        return FundItem(
                          title: funds[i]['title'],
                          imageUrl: imageUrl,
                          receivedAmount: rAmount.toDouble(),
                          totalAmount: tAmount.toDouble(),
                          lastDate: DateTime.parse(funds[i]['lastDate']),
                          fundId: funds[i]["_id"],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
