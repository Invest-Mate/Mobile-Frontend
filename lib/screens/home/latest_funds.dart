import 'dart:convert';
import 'dart:io';

import 'package:crowd_application/screens/all_latest_funds.dart/all_funds_screen.dart';
import 'package:crowd_application/widgets/fund_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LatestFunds extends StatefulWidget {
  const LatestFunds({Key? key}) : super(key: key);

  @override
  State<LatestFunds> createState() => _LatestFundsState();
}

class _LatestFundsState extends State<LatestFunds> {
  Future<Map> getLatestFunds() async {
    Map result = {};
    try {
      final uri =
          Uri.parse("https://fundzer.herokuapp.com/api/fund/get-all-funds");
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final http.Response res = await http.get(uri, headers: headers);

      final document = jsonDecode(res.body);
      result = {
        "status": "success",
        "data": document["data"]["data"],
      };
      // return document;
    } catch (e) {
      result = {
        "status": "fail",
      };
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0, left: 15.0, bottom: 4),
          child: Text(
            'Latest CrowdFunds',
            textAlign: TextAlign.left,
            textScaleFactor: 1.3,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        FutureBuilder(
            future: getLatestFunds(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    LoadingFund(),
                    LoadingFund(),
                    LoadingFund(),
                  ],
                );
              }
              if (snapshot.data["status"] != "success") {
                return const SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      "Something went wrong.",
                      textScaleFactor: 2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
              final latestFunds = snapshot.data["data"];

              return Container(
                // height: 100,
                constraints: const BoxConstraints(),
                width: double.maxFinite,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: latestFunds.length > 5 ? 5 : latestFunds.length,
                  itemBuilder: (context, i) {
                    int rAmount = latestFunds[i]['receivedAmount'];
                    int tAmount = latestFunds[i]['projectedAmount'];
                    String imageUrl = latestFunds[i]['imageCover'];
                    return FundItem(
                      title: latestFunds[i]['title'],
                      imageUrl: imageUrl,
                      receivedAmount: rAmount.toDouble(),
                      totalAmount: tAmount.toDouble(),
                      lastDate: DateTime.parse(latestFunds[i]['lastDate']),
                      fundId: latestFunds[i]["_id"],
                    );
                  },
                ),
              );
            }),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AllFundsScreen(),
                  ),
                );
              },
              child: const Text(
                'View more',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class LoadingFund extends StatelessWidget {
  const LoadingFund({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
