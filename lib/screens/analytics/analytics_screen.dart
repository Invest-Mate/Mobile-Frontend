import 'package:crowd_application/screens/analytics/show_widget.dart';
import 'package:crowd_application/screens/analytics/tempcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsScreen extends StatelessWidget {
  AnalyticsScreen({Key? key, required this.ownerId, required this.fundId})
      : super(key: key);
  final String ownerId;
  final String fundId;
  /*
  Fund_id - fetch fund details
  receivedAmount (amount collected)  (double)
  totalAmount  (double)
  lastDate (DateTime)
  creationDate (DateTime)
  numPeople  - No of  people who donated (double)
  Average_money_received ( we would need a middleware to calculate this?)
  */
  final double totalAmount = 500000;
  final double reveivedAmount = 345600;
  final DateTime lastDate = DateTime.now().add(const Duration(days: 210));
  final DateTime creationDate = DateTime.now().subtract(
    const Duration(days: 8),
  );

  @override
  Widget build(BuildContext context) {
    final List<_PieData> pieData = [
      _PieData(
        "Amount Collected \n (Rs $reveivedAmount)",
        reveivedAmount,
        text: reveivedAmount.toString(),
      ),
      _PieData(
        "Remaining Amount \n (Rs ${totalAmount - reveivedAmount})",
        totalAmount - reveivedAmount,
        text: (totalAmount - reveivedAmount).toString(),
      ),
    ];
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
              'Fund',
              style: TextStyle(
                color: Color.fromRGBO(254, 161, 21, 1),
              ),
            ),
            // SizedBox(
            //   width: 10,
            // ),
            Text(
              'Analytics',
              style: TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            // width: MediaQuery.of(context).size.width * 0.9,
            child: SfCircularChart(
              // backgroundColor: Colors.amber,
              margin: EdgeInsets.zero,
              palette: const [
                Colors.orange,
                Color.fromARGB(255, 110, 154, 176)
              ],
              legend: Legend(
                title: LegendTitle(
                  text: "Overall Progress",
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                isVisible: true,
                position: LegendPosition.right,
                textStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                // isResponsive: true,
              ),
              series: <DoughnutSeries<_PieData, String>>[
                DoughnutSeries<_PieData, String>(
                  explode: true,
                  explodeGesture: ActivationMode.none,
                  explodeIndex: 0,
                  legendIconType: LegendIconType.diamond,
                  dataSource: pieData,
                  dataLabelMapper: (_PieData data, _) => data.text,
                  xValueMapper: (_PieData data, _) => data.legendText,
                  yValueMapper: (_PieData data, _) => data.yData,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ShowWidget(
            text: DateFormat('dd / MM / yyyy').format(creationDate),
            label: "Starting from:",
            icon: const Icon(Icons.calendar_month),
          ),
          ShowWidget(
            text: DateFormat('dd / MM / yyyy').format(lastDate),
            label: "Ends on:",
            icon: const Icon(Icons.calendar_month),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            indent: 45,
            thickness: 1.5,
            endIndent: 45,
          ),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: const Text(
              "Donations",
              textScaleFactor: 1.5,
              style: TextStyle(
                color: Color.fromARGB(255, 245, 128, 19),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              TempCard(
                text: "345",
                label: "Toal Number of Donations",
                icon: Icon(Icons.people_alt),
              ),
              TempCard(
                text: "Rs " + "50000",
                label: "Average Amount Donated",
                icon: Icon(Icons.trending_up_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PieData {
  _PieData(this.legendText, this.yData, {this.text});
  final String legendText;
  final num yData;
  final String? text;
}
