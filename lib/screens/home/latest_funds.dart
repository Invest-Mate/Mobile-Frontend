import 'package:crowd_application/screens/home/latest_fund_item.dart';
import 'package:flutter/material.dart';

class LatestFunds extends StatefulWidget {
  const LatestFunds({Key? key}) : super(key: key);

  @override
  State<LatestFunds> createState() => _LatestFundsState();
}

class _LatestFundsState extends State<LatestFunds> {
  final List<Map> _latestFunds = [
    {
      'title': 'Save Whales',
      'imageUrl':
          'https://ca-times.brightspotcdn.com/dims4/default/8580888/2147483647/strip/true/crop/6720x4480+0+0/resize/840x560!/quality/90/?url=https%3A%2F%2Fcalifornia-times-brightspot.s3.amazonaws.com%2F6a%2Fe0%2Fbbdd04f54920a6c08f0f2b27f8be%2Fla-photos-1staff-777764-me-dead-fin-whale-01-cmc.jpg',
      'receivedAmount': 320000.0,
      'totalAmount': 500000.0,
      'lastDate': DateTime(2023),
    },
    {
      'title': 'Cancer Treatment',
      'imageUrl':
          'https://www.cancer.gov/sites/g/files/xnrzdm211/files/styles/cgov_social_media/public/cgov_image/media_image/100/500/8/files/woman-with-headscarf-getting-chemo-treatment-article.jpg',
      'receivedAmount': 220000.0,
      'totalAmount': 500000.0,
      'lastDate': DateTime(2022, 12, 1),
    },
    {
      'title': 'Dog Shelter',
      'imageUrl':
          'https://media.4-paws.org/6/8/9/3/689354d6694789b45569cd647a6009e240b4afe7/VIER%20PFOTEN_2016-09-18_081-1927x1333-1920x1328.jpg',
      'receivedAmount': 420000.0,
      'totalAmount': 500000.0,
      'lastDate': DateTime(2022, 4, 15),
    },
    {
      'title': 'Save Paper',
      'imageUrl':
          'https://hhsclarionnews.com/wp-content/uploads/2020/10/1_11.jpg',
      'receivedAmount': 120000.0,
      'totalAmount': 500000.0,
      'lastDate': DateTime(2022, 3, 13),
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0, left: 15.0, bottom: 4),
          child: Text(
            'Latest CrowdFunds',
            textAlign: TextAlign.left,
            textScaleFactor: 1.3,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          // height: 100,
          constraints: const BoxConstraints(),
          width: double.maxFinite,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _latestFunds.length,
            itemBuilder: (context, i) => LatestFundItem(
              title: _latestFunds[i]['title'],
              imageUrl: _latestFunds[i]['imageUrl'],
              receivedAmount: _latestFunds[i]['receivedAmount'],
              totalAmount: _latestFunds[i]['totalAmount'],
              lastDate: _latestFunds[i]['lastDate'],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'View more',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    );
  }
}
