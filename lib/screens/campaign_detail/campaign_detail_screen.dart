import 'dart:convert';
import 'dart:developer';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_application/screens/analytics/analytics_screen.dart';
import 'package:crowd_application/screens/campaign_detail/proof_preview_widget.dart';
import 'package:crowd_application/utils/url_launcher.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;

class CampaignDetailScreen extends StatefulWidget {
  const CampaignDetailScreen(
      {Key? key, this.isMyFund = false, required this.fundId})
      : super(key: key);
  final bool isMyFund;
  final String fundId;
  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  // final String docId = "626e4c4c2e29d5c801261bdc";
  Future getFundDetails() async {
    final uri = Uri.parse(
        "https://fundzer.herokuapp.com/api/fund/get-fund/${widget.fundId}");
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final http.Response res = await http.get(uri, headers: headers);

    final document = jsonDecode(res.body);
    return document;
  }

  Future openPaymentGateway(String userId, String fundId) async {
    try {
      String ipAddress = await Ipify.ipv64();

      MyUrlLauncher launcher = MyUrlLauncher();
      final uri = Uri.parse(
          "https://fundzer.herokuapp.com/api/transaction/payment?userId=$userId&&fundId=$fundId&&ip=$ipAddress");
      launcher.launchInWebViewOrVC(uri);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final cUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: FutureBuilder(
          future: getFundDetails(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data["status"] != "success") {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: Colors.black,
                ),
                body: const Center(
                  child: Text("Failed to load data."),
                ),
              );
            }
            final fundData = snapshot.data["data"];
            log(fundData.toString());
            // amount
            final receivedAmount = fundData["receivedAmount"];
            final totalAmount = fundData["projectedAmount"];
            double progress = (receivedAmount / totalAmount).toDouble() * 100;

            // last date
            DateTime lastDate = DateTime.parse(fundData["lastDate"]);
            final timeLeft = lastDate.difference(DateTime.now()).inDays;

            // proofs
            List proofs = fundData["proofs"];
            return CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                centerTitle: true,
                automaticallyImplyLeading: true,
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.share))
                ],
                backgroundColor: Colors.blueGrey[800],
                pinned: true,
                expandedHeight: 300.0,
                titleSpacing: 10.0,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1.1,
                  centerTitle: true,
                  // titlePadding: EdgeInsets.symmetric(),
                  collapseMode: CollapseMode.parallax,
                  title: Text(
                    fundData["title"],
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    // textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  background: CachedNetworkImage(
                    imageUrl: fundData["imageCover"],
                    fit: BoxFit.cover,
                    errorWidget: (context, text, err) => const Center(
                        child: Icon(
                      Icons.error_outline_outlined,
                    )),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    //  raised so far and total,
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Raised so far',
                                textScaleFactor: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rs ' +
                                        NumberFormat.compact()
                                            .format(receivedAmount),
                                    textScaleFactor: 1.5,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2.5,
                                  ),
                                  Text(
                                    "${progress.roundToDouble()}%",
                                    textScaleFactor: 0.9,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Target',
                                textScaleFactor: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "Rs " +
                                    NumberFormat.compact().format(totalAmount),
                                textScaleFactor: 1.5,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    //progress bar
                    Slider(
                      thumbColor: Colors.lightGreen,
                      value: progress,
                      max: 100,
                      min: 0,
                      label: '78%',
                      activeColor: Colors.teal,
                      onChanged: (val) {},
                    ),
                    //total donars and time left
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: <Widget>[
                          TextButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.people_alt_outlined),
                            label: Text(
                              NumberFormat.compact()
                                  .format(fundData["numOfPeople"]),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              timeLeft.isNegative
                                  ? 'Expired'
                                  : timeLeft > 28
                                      ? '${(timeLeft / 30).round()} Months left'
                                      : '$timeLeft Days left',
                              style: const TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      indent: 25,
                      endIndent: 25,
                      thickness: 2,
                    ),
                    // description
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                      child: Text(
                        'Description',
                        textScaleFactor: 1.5,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                      ),
                      child: ReadMoreText(
                        fundData["description"],
                        trimLines: 5,
                        trimLength: 165,
                        trimCollapsedText: 'Read more',
                        trimExpandedText: 'Show less.',
                        trimMode: TrimMode.Length,
                        textAlign: TextAlign.start,
                        moreStyle: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                        lessStyle: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 138, 137, 137),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      indent: 25,
                      endIndent: 25,
                      thickness: 2,
                    ),
                    // Proofs
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                      child: Text(
                        'Proofs',
                        textScaleFactor: 1.5,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 5),
                      child: SizedBox(
                        height: 100,
                        width: double.maxFinite,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: proofs.length,
                          itemBuilder: (context, i) => ProofPreview(
                            fileName: proofs[i],
                          ),
                        ),
                      ),
                    ),
                    //send donations button
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 25, right: 25, bottom: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            primary: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 15)),
                        onPressed: () {
                          if (cUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Login or Signup first.")),
                            );
                          } else {
                            openPaymentGateway(
                              cUser.uid.toString(),
                              fundData["_id"].toString(),
                            );
                            if (widget.isMyFund) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AnalyticsScreen(
                                    fundId: widget.fundId,
                                    ownerId: fundData["createdBy"],
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(widget.isMyFund
                            ? 'View Analytics'
                            : 'Send Donation'),
                      ),
                    ),
                  ],
                ),
              ),
            ]);
          }),
    );
  }
}
