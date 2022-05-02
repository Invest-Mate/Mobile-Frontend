import 'dart:convert';
import 'dart:developer';

import 'dart:io';

import 'package:crowd_application/widgets/fund_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllFundsScreen extends StatelessWidget {
  const AllFundsScreen({Key? key}) : super(key: key);
  Future getAllFunds() async {
    final uri =
        Uri.parse("https://fundzer.herokuapp.com/api/fund/get-all-funds");
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final http.Response res = await http.get(uri, headers: headers);

    final document = jsonDecode(res.body);
    return document;
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
              '🔥Trend',
              style: TextStyle(
                color: Color.fromRGBO(254, 161, 21, 1),
              ),
            ),
            Text(
              'ing',
              style: TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: getAllFunds(),
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
                  "Something went wrong.",
                  textScaleFactor: 2,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          final myfunds = snapshot.data["data"]["data"];

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
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}
