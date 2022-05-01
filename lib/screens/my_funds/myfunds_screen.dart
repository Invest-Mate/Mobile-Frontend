import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crowd_application/widgets/fund_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyFundsScreen extends StatefulWidget {
  const MyFundsScreen({Key? key}) : super(key: key);

  @override
  State<MyFundsScreen> createState() => _MyFundsScreenState();
}

class _MyFundsScreenState extends State<MyFundsScreen> {
  String userId = "625b147b8d09db8b40e19f42";
  Future getMyFunds() async {
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

    Map result = {"status": "success", "data": allFunds};
    return result;
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
      body: FutureBuilder(
        future: getMyFunds(),
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
                  textScaleFactor: 2,
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
                    String imageUrl =
                        "https://fundzer.herokuapp.com/images/funds/${myfunds[i]['imageCover']}";
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
      ),
    );
  }
}
