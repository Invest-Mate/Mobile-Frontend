import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class TrendingFunds extends StatelessWidget {
  const TrendingFunds({Key? key}) : super(key: key);
  static final List<Map> _campaigns = [
    {
      'name': 'Russia-Ukraine War',
      'imageUrl':
          'https://images02.military.com/sites/default/files/styles/full/public/2021-10/oklahoma.jpg'
    },
    {
      'name': 'Animal Care Funds',
      'imageUrl': 'http://www.goodnet.org/photos/620x0/30012_hd.jpg'
    },
    {
      'name': 'Rural Education',
      'imageUrl':
          'https://inclusive-solutions.com/wp-content/uploads/2021/08/iStock-1223141903.jpg'
    },
  ];

  static final List<Widget> _items = _campaigns.map((camp) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: Colors.blueGrey[200],
              borderRadius: BorderRadius.circular(8)),
          child: Stack(fit: StackFit.expand, children: [
            Image.network(
              camp['imageUrl'],
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  camp['name'],
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
        );
      },
    );
  }).toList();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: CarouselSlider(
        items: _items,
        options: CarouselOptions(
          autoPlay: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          enlargeCenterPage: true,
        ),
      ),
    );
  }
}
