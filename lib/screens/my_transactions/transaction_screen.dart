import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({
    Key? key,
    required this.transactionId,
  }) : super(key: key);
  final String transactionId;

  Future getTransaction() async {
    final uri = Uri.parse(
        "https://fundzer.herokuapp.com/api/transaction/get-transaction/$transactionId");
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final http.Response res = await http.get(uri, headers: headers);
    final document = jsonDecode(res.body);

    return document;
  }

  Future getFundDetail(String fundId) async {
    final uri =
        Uri.parse("https://fundzer.herokuapp.com/api/fund/get-fund/$fundId");
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final http.Response res = await http.get(uri, headers: headers);
    final document = jsonDecode(res.body);
    return document;
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
              'Tranaction',
              style: TextStyle(
                color: Color.fromRGBO(254, 161, 21, 1),
              ),
            ),
            Text(
              'Details',
              style: TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      body: FutureBuilder(
          future: getTransaction(),
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
                    "Failed to load transaction Details.",
                    textScaleFactor: 2,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
            //
            final snapshotData = snapshot.data["data"];
            // trans data

            final double amount = snapshotData["amountFunded"].toDouble();
            final String banktransactionID = snapshotData["trans_id"];
            final String acountNumber = snapshotData["credited_To"];
            final String phoneNumber = snapshotData["trans_phn"].toString();
            final String holderName = snapshotData["trans_name"];
            final DateTime date = DateTime.parse(snapshotData["trans_date"]);
            log(snapshotData["status"].toString());
            bool isSuccessful =
                snapshotData["status"] == "TXN_SUCCESS" ? true : false;

            //
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          tileColor: isSuccessful ? Colors.green : Colors.red,
                          title: const Text(
                            "STATUS:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          trailing: Text(
                            isSuccessful ? "SUCCESS!" : "FAILED!",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            "Donated to:",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green),
                          ),
                        ),
                        //
                        // fetching some details
                        FutureBuilder(
                            future: getFundDetail(snapshotData["fundId"]),
                            builder: (context, AsyncSnapshot snapshot2) {
                              bool isLoading = snapshot2.connectionState ==
                                  ConnectionState.waiting;
                              if (!isLoading) {
                                log(snapshot2.data.toString());
                              }

                              const String imageUrl =
                                  "https://wwfint.awsassets.panda.org/img/original/humpback_whale_111823.jpg";
                              return ListTile(
                                leading: Container(
                                  height: 40,
                                  width: 40,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.network(
                                    isLoading
                                        ? imageUrl
                                        : snapshot2.data["data"]["imageCover"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  !isLoading
                                      ? snapshot2.data["data"]["title"]
                                      : "Title",
                                  textScaleFactor: 1,
                                ),
                                subtitle: Text(
                                  DateFormat("dd-MMMM-yyyy").format(date),
                                  textScaleFactor: 1,
                                ),
                                trailing: Text(
                                  "Rs " + NumberFormat.compact().format(amount),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            }),
                        if (!isSuccessful)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Text(
                              "If amount was deducted from your account, it will be refunded in 3-4 working days.",
                              textAlign: TextAlign.center,
                              textScaleFactor: 0.9,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        const Divider(
                          thickness: 1.5,
                          indent: 15,
                          endIndent: 15,
                        ),
                        const ListTile(
                          leading: Icon(
                            Icons.info_outlined,
                            color: Colors.black,
                          ),
                          minLeadingWidth: 10,
                          title: Text(
                            "Transfer Details",
                            textScaleFactor: 1.1,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            "Transaction ID",
                            textScaleFactor: 1,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: FittedBox(child: Text(banktransactionID)),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.copy,
                                color: Colors.black,
                              )),
                        ),
                        const Divider(
                          thickness: 1.5,
                          indent: 15,
                          endIndent: 15,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            "Debited from:",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green),
                          ),
                        ),
                        ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.account_balance),
                            ],
                          ),
                          minLeadingWidth: 15,
                          title: const Text(
                            "Account Number",
                            textScaleFactor: 1,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text("************" +
                              acountNumber.substring(acountNumber.length - 4)),
                        ),
                        ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.person),
                            ],
                          ),
                          minLeadingWidth: 15,
                          title: const Text(
                            "Account Holder Name",
                            textScaleFactor: 1,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(holderName),
                        ),
                        ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.person),
                            ],
                          ),
                          minLeadingWidth: 15,
                          title: const Text(
                            "Phone Number",
                            textScaleFactor: 1,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text("*******" +
                              phoneNumber.substring(phoneNumber.length - 3)),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.maxFinite, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          )),
                      onPressed: () {},
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
