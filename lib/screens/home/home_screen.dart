import 'package:crowd_application/screens/add_fundraiser/new_fund_screen.dart';
import 'package:crowd_application/widgets/drawer.dart';
import 'package:crowd_application/screens/home/categories_list.dart';
import 'package:crowd_application/screens/home/latest_funds.dart';
import 'package:crowd_application/screens/home/search_bar_button.dart';
import 'package:crowd_application/screens/home/trending_funds.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
              'FUNDZ',
              style: TextStyle(
                color: Color.fromRGBO(254, 161, 21, 1),
              ),
            ),
            Text(
              'ER',
              style: TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(254, 161, 21, 1),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NewFundScreen()),
          );
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            SearchButton(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: CategoryList(),
            ),
            TrendingFunds(),
            LatestFunds(),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
