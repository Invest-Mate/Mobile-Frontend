import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({
    Key? key,
    required this.transactionId,
  }) : super(key: key);
  final String transactionId;
  final String fundName = "Save Whales";
  final String imageUrl =
      "https://wwfint.awsassets.panda.org/img/original/humpback_whale_111823.jpg";
  final double amount = 5000;
  final String banktransactionID = "T2215651651646498654654";
  final String acountNumber = "3214";
  final String holderName = "Rocky bhai";
  @override
  Widget build(BuildContext context) {
    //
    final DateTime date = DateTime.now();
    final bool isSuccessful = int.parse(transactionId) % 2 == 0 ? true : false;
    //
    //
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                          fontWeight: FontWeight.w500, color: Colors.green),
                    ),
                  ),
                  ListTile(
                    leading: Container(
                      height: 40,
                      width: 40,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      fundName,
                      textScaleFactor: 1,
                    ),
                    subtitle: Text(
                      DateFormat("dd-MMMM-yyyy").format(date),
                      textScaleFactor: 1,
                    ),
                    trailing: Text(
                      "Rs $amount",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (!isSuccessful)
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
                    subtitle: Text(banktransactionID),
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
                          fontWeight: FontWeight.w500, color: Colors.green),
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
                    subtitle: Text("**** **** **** $acountNumber"),
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
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
      ),
    );
  }
}
