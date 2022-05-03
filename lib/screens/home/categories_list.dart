import 'package:crowd_application/screens/category_search/category_search.dart';
import 'package:crowd_application/screens/home/category_card.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int _activeIndex = 0;
  static final List<String> _categories = [
    'All',
    '🐼  Animal',
    '🥷  War',
    '⚗️  Scientific',
    '📚  Education',
    '🌳  Environmental',
    '💰  Financial',
    '😇  Poverty',
    '🩺  Health',
    '🤒  Disease',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
      ),
      width: double.maxFinite,
      child: Row(
        children: [
          SizedBox(
            height: 35,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, i) => InkWell(
                onTap: () {
                  setState(() {
                    _activeIndex = i;
                  });
                  if (_categories[i] != "All") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CategorySearch(
                          categoryName: (_categories[i].substring(2)).trim(),
                        ),
                      ),
                    );
                  }
                },
                child: CategoryCard(
                  cardName: _categories[i],
                  itemIndex: i,
                  activeIndex: _activeIndex,
                ),
              ),
            ),
          ),
          const Icon(
            Icons.arrow_right,
            size: 25,
          )
        ],
      ),
    );
  }
}
