import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crowd_application/screens/my_transactions/transaction_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyTransactionsScreen extends StatelessWidget {
  const MyTransactionsScreen({Key? key}) : super(key: key);

  Future getTransactions(String userId) async {
    Map result = {};
    try {
      List allTrans = [];
      final uri =
          Uri.parse("https://fundzer.herokuapp.com/api/user/get-user/$userId");
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final http.Response res = await http.get(uri, headers: headers);
      final document = jsonDecode(res.body);
      List transactions = document["user_Transactions"];
      for (var trans in transactions) {
        final uri = Uri.parse(
            "https://fundzer.herokuapp.com/api/transaction/get-transaction/${trans["_id"]}");
        final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
        final http.Response res = await http.get(uri, headers: headers);

        final document = jsonDecode(res.body);
        allTrans.add(document["data"]);
      }

      result = {"status": "success", "data": allTrans};
    } catch (e) {
      result = {
        "status": "fail",
      };
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final cUser = FirebaseAuth.instance.currentUser;

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
      body: cUser != null
          ? FutureBuilder(
              future: getTransactions(cUser.uid),
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
                log(transactions.toString());
                if (transactions.isEmpty || transactions == null) {
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
              },
            )
          : const Center(
              child: Text("Login First."),
            ),
    );
  }
}
