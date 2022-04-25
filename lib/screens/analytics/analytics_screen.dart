import 'package:crowd_application/screens/analytics/show_widget.dart';
import 'package:crowd_application/screens/analytics/tempcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class AnalyticsScreen extends StatelessWidget {
  AnalyticsScreen({Key? key, required this.ownerId, required this.fundId})
      : super(key: key);
  final String ownerId;
  final String fundId;
  final double totalAmount = 500000;
  final double reveivedAmount = 345600;
  final DateTime lastDate = DateTime.now().add(const Duration(days: 210));
  final DateTime creationDate = DateTime.now().subtract(
    const Duration(days: 8),
  );

  @override
  Widget build(BuildContext context) {
    final List<DonationsData> donationsData = [
      DonationsData(3500, DateTime.now().add(const Duration(days: 0))),
      DonationsData(2700, DateTime.now().add(const Duration(days: 1))),
      DonationsData(3400, DateTime.now().add(const Duration(days: 2))),
      DonationsData(1200, DateTime.now().add(const Duration(days: 3))),
      DonationsData(600, DateTime.now().add(const Duration(days: 4))),
      DonationsData(4560, DateTime.now().add(const Duration(days: 5))),
      DonationsData(3200, DateTime.now().add(const Duration(days: 6))),
      DonationsData(6050, DateTime.now().add(const Duration(days: 7))),
      DonationsData(6554, DateTime.now().add(const Duration(days: 8))),
      DonationsData(8450, DateTime.now().add(const Duration(days: 9))),
      DonationsData(6465, DateTime.now().add(const Duration(days: 10))),
      DonationsData(9840, DateTime.now().add(const Duration(days: 11))),
      DonationsData(684, DateTime.now().add(const Duration(days: 12))),
      DonationsData(1585, DateTime.now().add(const Duration(days: 13))),
      DonationsData(6000, DateTime.now().add(const Duration(days: 14))),
      DonationsData(1568, DateTime.now().add(const Duration(days: 15))),
      DonationsData(2568, DateTime.now().add(const Duration(days: 16))),
      DonationsData(8568, DateTime.now().add(const Duration(days: 17))),
      DonationsData(6568, DateTime.now().add(const Duration(days: 18))),
      DonationsData(8568, DateTime.now().add(const Duration(days: 19))),
      DonationsData(568, DateTime.now().add(const Duration(days: 20))),
      DonationsData(5568, DateTime.now().add(const Duration(days: 21))),
      DonationsData(9568, DateTime.now().add(const Duration(days: 22))),
      DonationsData(8568, DateTime.now().add(const Duration(days: 23))),
      DonationsData(3568, DateTime.now().add(const Duration(days: 24))),
      DonationsData(4568, DateTime.now().add(const Duration(days: 25))),
    ];
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
      body: SingleChildScrollView(
        child: Column(
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
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                crossAxisCount: 2,
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
                  TempCard(
                    text: "Rs " + "150000",
                    label: "Highest Donation",
                    icon: Icon(Icons.trending_up_rounded),
                  ),
                  TempCard(
                    text: "Rs " + "200",
                    label: "Lowest Donation",
                    icon: Icon(Icons.trending_down),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 20, right: 10),
              height: MediaQuery.of(context).size.width * 0.6,
              width: MediaQuery.of(context).size.width,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <AreaSeries<DonationsData, String>>[
                  AreaSeries<DonationsData, String>(
                      yAxisName: "Amount",
                      // dataLabelMapper: (datum, index) {},
                      isVisible: true,
                      isVisibleInLegend: false,
                      // Bind data source
                      color: const Color.fromRGBO(254, 161, 21, 1),
                      dataSource: donationsData,
                      xValueMapper: (DonationsData donations, _) =>
                          DateFormat("dd-MMMM-yy").format(donations.date),
                      xAxisName: "Time",
                      yValueMapper: (DonationsData donations, _) =>
                          donations.amount)
                ],
              ),
            ),
          ],
        ),
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

class DonationsData {
  DonationsData(this.amount, this.date);
  final double amount;
  final DateTime date;
}
