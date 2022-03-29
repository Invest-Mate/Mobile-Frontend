import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {Key? key,
      required this.cardName,
      required this.activeIndex,
      required this.itemIndex})
      : super(key: key);
  final String cardName;
  final int activeIndex;
  final int itemIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: activeIndex == itemIndex
            ? const Color.fromRGBO(254, 161, 21, 1)
            : const Color.fromARGB(255, 240, 240, 240),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Text(
          cardName,
          style: TextStyle(
            color: activeIndex == itemIndex ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
