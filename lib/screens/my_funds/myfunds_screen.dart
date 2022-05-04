import 'dart:convert';
import 'dart:io';

import 'package:crowd_application/widgets/fund_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyFundsScreen extends StatefulWidget {
  const MyFundsScreen({Key? key}) : super(key: key);

  @override
  State<MyFundsScreen> createState() => _MyFundsScreenState();
}

class _MyFundsScreenState extends State<MyFundsScreen> {
  Future getMyFunds(String userId) async {
    Map result = {};
    try {
      List allFunds = [];
      final uri =
          Uri.parse("https://fundzer.herokuapp.com/api/user/get-user/$userId");
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final http.Response res = await http.get(uri, headers: headers);
      final document = jsonDecode(res.body);
      List funds = document["MyFunds"];
      for (var fundData in funds) {
        final uri = Uri.parse(
            "https://fundzer.herokuapp.com/api/fund/get-fund/${fundData["_id"]}");
        final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
        final http.Response res = await http.get(uri, headers: headers);

        final document = jsonDecode(res.body);
        allFunds.add(document["data"]);
      }

      result = {"status": "success", "data": allFunds};
    } catch (e) {
      result = {"status": "failed"};
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final cUser = FirebaseAuth.instance.currentUser;
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
              'My',
              style: TextStyle(
                color: Color.fromRGBO(254, 161, 21, 1),
              ),
            ),
            Text(
              'Funds',
              style: TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      body: cUser != null
          ? FutureBuilder(
              future: getMyFunds(cUser.uid),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: double.maxFinite,
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
                        "No funds were found.",
                        textScaleFactor: 1.5,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }

                final myfunds = snapshot.data["data"];

                return SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(),
                    width: double.maxFinite,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: myfunds.length,
                        itemBuilder: (context, i) {
                          int rAmount = myfunds[i]['receivedAmount'];
                          int tAmount = myfunds[i]['projectedAmount'];
                          String imageUrl = myfunds[i]['imageCover'];
                          return FundItem(
                            title: myfunds[i]['title'],
                            imageUrl: imageUrl,
                            receivedAmount: rAmount.toDouble(),
                            totalAmount: tAmount.toDouble(),
                            lastDate: DateTime.parse(myfunds[i]['lastDate']),
                            fundId: myfunds[i]["_id"],
                            isMyFund: true,
                          );
                        }),
                  ),
                );
              },
            )
          : const Center(
              child: Text("Login First."),
            ),
    );
  }
}
