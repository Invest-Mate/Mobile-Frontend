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
    } catch (e) {
      log(e.toString());
    }
    return {"status": "failed"};
  }

  Future<Map> getGraphData(String fundId, DateTime creationDate) async {
    Map result = {};
    List<DonationsData> donations = [];
    String initialDate = creationDate.toIso8601String();
    initialDate = initialDate.substring(0, 10);
    Map<String, double> datesData = {
      initialDate: 0.0,
    };
    try {
      final http.Response response1 = await http.get(
          Uri.parse(
            "https://fundzer.herokuapp.com/api/transaction/get-fund-transaction/$fundId",
          ),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      final List allFundTransactions =
          jsonDecode(response1.body)["data"]["data"];
      // log(allFundTransactions.toString());
      for (var fund in allFundTransactions) {
        String date = fund["trans_date"];

        date = date.substring(0, 10);
        if (datesData[date] != null) {
          datesData[date] = datesData[date]! + fund["amountFunded"];
        } else {
          datesData[date] = fund["amountFunded"].toDouble();
        }
      }
      datesData.forEach(
        (date, amount) {
          donations.add(DonationsData(amount, DateTime.parse(date)));
        },
      );
      donations.sort((a, b) => a.date.compareTo(b.date));

      result = {
        "status": "success",
        "data": donations,
      };
    } catch (e) {
      result = {
        "status": "fail",
      };
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    int totalAmount;
    int receivedAmount;
    DateTime lastDate;
    DateTime creationDate;

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
                    child: FutureBuilder(
                      future: getGraphData(fundId, creationDate),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Text("Loading Data!"),
                          );
                        }
                        if (snapshot.data["status"] == "failed") {
                          return const Center(
                            child: Text("Failed to Load Data!"),
                          );
                        }
                        List<DonationsData> donationsData =
                            snapshot.data["data"];
                        return SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          primaryYAxis:
                              NumericAxis(numberFormat: NumberFormat.compact()),
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
                                    DateFormat("dd-MMMM-yy")
                                        .format(donations.date),
                                xAxisName: "Time",
                                yValueMapper: (DonationsData donations, _) =>
                                    donations.amount)
                          ],
                        );
                      },
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
