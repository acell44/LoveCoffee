import 'package:flutter/material.dart';
import 'coffee_detail_page.dart';

class CoffeeItem extends StatelessWidget {
  final String name;
  final String imagePath;
  final String category;

  const CoffeeItem({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.category,
  }) : super(key: key);

  double _getPrice() {
    switch (name) {
      case 'Matcha Latte':
        return 10.000;
      case 'Iced Salted Caramel Latte':
        return 15.000;
      // Tambahkan harga menu lainnya
      default:
        return 10.000;
    }
  }

  String _formatNumber(double number) {
    return number.toStringAsFixed(3).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoffeeDetailPage(
              name: name,
              imagePath: imagePath,
              category: category,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp${_formatNumber(_getPrice())}',
                        style: TextStyle(
                          color: Color.fromARGB(255, 87, 34, 2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 87, 34, 2),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
