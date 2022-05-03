import 'dart:convert';

import 'dart:io';

import 'package:crowd_application/widgets/fund_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategorySearch extends StatelessWidget {
  const CategorySearch({Key? key, required this.categoryName})
      : super(key: key);
  final String categoryName;
  Future<Map> getCategoryFunds() async {
    Map result = {};
    try {
      final uri = Uri.parse(
          "https://fundzer.herokuapp.com/api/fund/search?category=$categoryName");
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
    return result;
  }

  @override
  Widget build(BuildContext context) {
    int len = categoryName.length ~/ 2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              categoryName.substring(0, len),
              style: const TextStyle(
                color: Color.fromRGBO(254, 161, 21, 1),
              ),
            ),
            Text(
              categoryName.substring(len),
              style: const TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: getCategoryFunds(),
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
                  "No funds for \nthat category found..",
                  textScaleFactor: 1.2,
                  textAlign: TextAlign.center,
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
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}
