import 'package:crowd_application/screens/search/search_screen.dart';
import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: const Color.fromRGBO(161, 161, 161, 1),
            ),
            borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width * 0.7,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: const [
            Icon(
              Icons.search,
              color: Color.fromRGBO(161, 161, 161, 1),
            ),
            Expanded(
              child: Center(
                widthFactor: 0.7,
                child: Text(
                  'Search Crowdfunds',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(161, 161, 161, 1),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
