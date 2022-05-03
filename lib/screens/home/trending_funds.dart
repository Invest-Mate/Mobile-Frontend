import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crowd_application/screens/campaign_detail/campaign_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TrendingFunds extends StatelessWidget {
  const TrendingFunds({Key? key}) : super(key: key);
  Future<Map> getPopularFunds() async {
    Map result = {};
    try {
      final uri = Uri.parse("https://fundzer.herokuapp.com/api/fund/top-funds");
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
      final http.Response res = await http.get(uri, headers: headers);

      final document = jsonDecode(res.body);
      final data = document["data"]["stats"];

      result = {
        "status": "success",
        "data": data,
      };
      // return document;
    } catch (e) {
      result = {
        "status": "fail",
      };
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _loadingItems = [
      const LoadingFund(),
      const LoadingFund(),
      const LoadingFund(),
    ];

    return FutureBuilder(
      future: getPopularFunds(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.only(top: 10),
            child: CarouselSlider(
              items: _loadingItems,
              options: CarouselOptions(
                autoPlay: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                enlargeCenterPage: true,
              ),
            ),
          );
        }
        if (snapshot.data["status"] != "success") {
          return const SizedBox(
            height: 200,
            child: Center(
              child: Text(
                "Something went wrong.",
                textScaleFactor: 2,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
        final List funds = snapshot.data["data"];
        List<Widget> items = funds.map(
          (fund) {
            return Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CampaignDetailScreen(fundId: fund["_id"])));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[200],
                        borderRadius: BorderRadius.circular(8)),
                    child: Stack(fit: StackFit.expand, children: [
                      CachedNetworkImage(
                        imageUrl: fund['imageCover'],
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorWidget: (context, text, err) => const Center(
                            child: Icon(
                          Icons.error_outline_outlined,
                        )),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: Text(
                            fund['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.5,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                );
              },
            );
          },
        ).toList();
        return Container(
          margin: const EdgeInsets.only(top: 10),
          child: CarouselSlider(
            items: items,
            options: CarouselOptions(
              autoPlay: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              enlargeCenterPage: true,
            ),
          ),
        );
      },
    );
  }
}

class LoadingFund extends StatelessWidget {
  const LoadingFund({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
