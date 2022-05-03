import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crowd_application/screens/analytics/analytics_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);
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
        log(fund["amountFunded"].toString());
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
      for (var donation in donations) {
        log("Date: " + donation.date.toString());
        log("Amount: " + donation.amount.toString());
      }
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
    getGraphData("626e5ea32e29d5c801261c28",
        DateTime.now().subtract(const Duration(days: 60)));
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 15, bottom: 20, right: 10),
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: getGraphData("626e5ea32e29d5c801261c28",
                DateTime.now().subtract(const Duration(days: 100))),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text("Loading Data!"),
                );
              }
              if (snapshot.data["status"] == "failed") {
                return const Center(
                  child: Text("Failed to Load Data!"),
                );
              }
              List<DonationsData> donationsData = snapshot.data["data"];
              return SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(numberFormat: NumberFormat.compact()),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
