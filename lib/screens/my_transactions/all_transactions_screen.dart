import 'dart:convert';
import 'dart:io';

import 'package:crowd_application/screens/my_transactions/transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyTransactionsScreen extends StatelessWidget {
  const MyTransactionsScreen({Key? key}) : super(key: key);
  final String userId = "626d04b2bd0731db19806f3e";
  Future getTransactions() async {
    Map result = {};
    try {
      final uri = Uri.parse(
          "https://fundzer.herokuapp.com/api/transaction/all-transactions?id=$userId");
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final http.Response res = await http.get(uri, headers: headers);
      final document = jsonDecode(res.body);
      // log(document.toString());
      result = {"status": "success", "data": document["data"]["data"]};
    } catch (e) {
      result = {
        "status": "fail",
      };
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Tran',
              style: TextStyle(
                color: Color.fromRGBO(254, 161, 21, 1),
              ),
            ),
            Text(
              'sactions',
              style: TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      body: FutureBuilder(
          future: getTransactions(),
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
                    "No Transactions were found.",
                    textScaleFactor: 1.5,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }

            List transactions = snapshot.data["data"];

            if (transactions.isEmpty) {
              return const Center(
                child: Text(
                  "Transactions not found!",
                  textScaleFactor: 1.5,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: transactions.length,
                  itemBuilder: (context, i) => TransactionItem(
                    title: transactions[i]['trans_id'],
                    status: transactions[i]['status'],
                    date: DateTime.parse(transactions[i]['trans_date']),
                    amount: transactions[i]['amountFunded'].toDouble(),
                    transactionId: transactions[i]["_id"],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
