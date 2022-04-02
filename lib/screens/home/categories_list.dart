import 'package:crowd_application/screens/home/category_card.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  static final List<String> _categories = [
    'All',
    '📚  Education',
    '💊  Medical',
    '🐼  Animals'
  ];
  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int _activeIndex = 0;

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
              itemCount: CategoryList._categories.length,
              itemBuilder: (context, i) => InkWell(
                onTap: () {
                  setState(() {
                    _activeIndex = i;
                  });
                },
                child: CategoryCard(
                  cardName: CategoryList._categories[i],
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
