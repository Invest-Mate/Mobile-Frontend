import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crowd_application/screens/analytics/show_widget.dart';
import 'package:crowd_application/screens/analytics/tempcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:http/http.dart' as http;

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key, required this.ownerId, required this.fundId})
      : super(key: key);
  final String ownerId;
  final String fundId;
  Future<Map> getFundStats() async {
    try {
      final http.Response response1 = await http.get(
          Uri.parse(
            "http://fundzer.herokuapp.com/api/fund/get-fund/$fundId",
          ),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      final data1 = jsonDecode(response1.body);
      // log(data1.toString());
      // fetching imp data
      final target = data1["data"]["projectedAmount"];
      final createdAt = data1["data"]["createdAt"];
      final lastDate = data1["data"]["lastDate"];
      // log(data1["data"].toString());
      // request 2
      final http.Response response2 = await http.get(
          Uri.parse(
              "https://fundzer.herokuapp.com/api/transaction/fund-stats/$fundId"),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      final data2 = jsonDecode(response2.body);
      final Map result = data2["stats"][0];
      result.addAll(<String, dynamic>{
        "targetAmount": target,
        "creationDate": createdAt,
        "lastDate": lastDate,
        "status": "success",
      });
      return result;
    } catch (e) {}
    return {"status": "failed"};
  }

  @override
  Widget build(BuildContext context) {
    int totalAmount;
    int receivedAmount;
    DateTime lastDate;
    DateTime creationDate;
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
      body: FutureBuilder(
          future: getFundStats(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data["status"] == "failed") {
              return const Center(
                child: Text("Failed to Load Data!"),
              );
            }
            final data = snapshot.data;

            totalAmount = data["targetAmount"];
            receivedAmount = data["TotalamountDonated"];
            lastDate = DateTime.parse(data["lastDate"]);
            creationDate = DateTime.parse(data["creationDate"]);
            // pie data
            final List<_PieData> pieData = [
              _PieData(
                "Amount Collected" "\n( Rs " +
                    NumberFormat.compact().format(receivedAmount) +
                    ")",
                receivedAmount,
                text: receivedAmount.toString(),
              ),
              _PieData(
                "Remaining Amount" "\n( Rs " +
                    NumberFormat.compact()
                        .format(totalAmount - receivedAmount) +
                    ")",
                totalAmount - receivedAmount,
                text: (totalAmount - receivedAmount).toString(),
              ),
            ];
            return SingleChildScrollView(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      crossAxisCount: 2,
                      children: [
                        TempCard(
                          text: data["noOfDonations"].toString(),
                          label: "Toal Number of Donations",
                          icon: const Icon(Icons.people_alt),
                        ),
                        TempCard(
                          text: "Rs " +
                              NumberFormat.compact()
                                  .format(data["avgDonations"]),
                          label: "Average Amount Donated",
                          icon: const Icon(Icons.trending_up_sharp),
                        ),
                        TempCard(
                          text: "Rs " +
                              NumberFormat.compact()
                                  .format(data["maxDonation"]),
                          label: "Highest Donation",
                          icon: const Icon(Icons.trending_up_rounded),
                        ),
                        TempCard(
                          text: "Rs " +
                              NumberFormat.compact()
                                  .format(data["minDonation"]),
                          label: "Lowest Donation",
                          icon: const Icon(Icons.trending_down),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 15, bottom: 20, right: 10),
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
            );
          }),
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
