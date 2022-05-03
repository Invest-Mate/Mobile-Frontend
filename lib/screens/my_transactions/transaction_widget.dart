import 'package:crowd_application/screens/my_transactions/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(
      {Key? key,
      this.imageUrl =
          "https://www.mechamath.com/wp-content/uploads/2021/06/applications-of-quadratic-functions-find-profit.png?ezimgfmt=ng:webp/ngcb71",
      required this.title,
      required this.date,
      required this.amount,
      required this.transactionId,
      required this.status})
      : super(key: key);
  final String imageUrl;
  final String title;
  final DateTime date;
  final double amount;
  final String transactionId;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
      child: Card(
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TransactionScreen(
                  transactionId: transactionId,
                ),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          tileColor: Colors.white,
          leading: Container(
            height: 40,
            width: 40,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            title,
            textScaleFactor: 1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            DateFormat("dd-MMMM-yyyy").format(date),
            textScaleFactor: 1,
          ),
          trailing: Text(
            "Rs " + NumberFormat.compact().format(amount),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: status != "TXN_SUCCESS" ? Colors.red : Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
