// lib/widgets/category_selector.dart
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final Function(String) onCategorySelected;
  final String selectedCategory;

  const CategorySelector({
    Key? key,
    required this.onCategorySelected,
    required this.selectedCategory,
  }) : super(key: key);

  final List<String> categories = const [
    'All',
    'Coffee',
    'Snacks',
    'Tea',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onCategorySelected(categories[index]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: selectedCategory == categories[index]
                    ? Color.fromARGB(255, 54, 29, 12)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: selectedCategory == categories[index]
                        ? Colors.white
                        : Colors.black,
                    fontWeight: selectedCategory == categories[index]
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
