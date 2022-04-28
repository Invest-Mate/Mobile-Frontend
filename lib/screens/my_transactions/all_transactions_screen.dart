import 'package:crowd_application/screens/my_transactions/transaction_widget.dart';
import 'package:flutter/material.dart';

class MyTransactionsScreen extends StatelessWidget {
  const MyTransactionsScreen({Key? key}) : super(key: key);
  static final List<Map> _transactions = [
    {
      "title": "Save Whales",
      "date": DateTime.now().subtract(const Duration(days: 15)),
      "amount": 1500.00,
    },
    {
      "title": "Dog Shelter",
      "date": DateTime.now().subtract(const Duration(days: 25)),
      "amount": 800.00,
    },
    {
      "title": "Cancer Treatment",
      "date": DateTime.now().subtract(const Duration(days: 30)),
      "amount": 4600.00,
    }
  ];
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
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _transactions.length,
            itemBuilder: (context, i) => TransactionItem(
              title: _transactions[i]['title'],
              date: _transactions[i]['date'],
              amount: _transactions[i]['amount'],
              transactionId: i.toString(),
            ),
          ),
        ),
      ),
    );
  }
}
