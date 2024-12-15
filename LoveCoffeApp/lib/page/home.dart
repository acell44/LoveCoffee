import 'package:flutter/material.dart';
import 'package:lovecoffee/helpers/user_info.dart';
import 'package:lovecoffee/widgets/category_selector.dart';
import 'package:lovecoffee/widgets/coffee_item.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Gunakan ValueNotifier untuk kategori
  final ValueNotifier<String> _selectedCategoryNotifier = ValueNotifier('All');

  String _location = "Mengambil lokasi..."; // Pesan lokasi default

  // Ini isi dari kategori
  final List<Map<String, String>> coffeeItems = [
    {
      'name': 'Matcha Latte',
      'image': 'assets/images/MatchaLatte.jpg',
      'category': 'Coffee',
    },
    {
      'name': 'Iced Salted Caramel Latte',
      'image': 'assets/images/IcedSaltedCaramelLatte.jpg',
      'category': 'Coffee',
    },
    {
      'name': 'Oat Milk Latte',
      'image': 'assets/images/OatMilkLatte.jpg',
      'category': 'Coffee',
    },
    {
      'name': 'Chai Latte',
      'image': 'assets/images/ChaiLatte.jpg',
      'category': 'Coffee',
    },
    {
      'name': 'Croffle',
      'image': 'assets/images/Croffle.jpg',
      'category': 'Snacks',
    },
    {
      'name': 'French Toast',
      'image': 'assets/images/FrenchToast.jpg',
      'category': 'Snacks',
    },
    {
      'name': 'Waffle Ice Cream',
      'image': 'assets/images/WaffleIceCream.jpg',
      'category': 'Snacks',
    },
    {
      'name': 'French Fries',
      'image': 'assets/images/FrenchFries.jpg',
      'category': 'Snacks',
    },
    {
      'name': 'Ginger Tea',
      'image': 'assets/images/GingerTea.jpg',
      'category': 'Tea',
    },
    {
      'name': 'Floral Tea',
      'image': 'assets/images/FloralTea.jpg',
      'category': 'Tea',
    },
    {
      'name': 'Fruit Tea',
      'image': 'assets/images/FruitTea.jpg',
      'category': 'Tea',
    },
    {
      'name': 'Peppermint Tea',
      'image': 'assets/images/PeppermintTea.jpg',
      'category': 'Tea',
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // ngambil lokasi pas widget diinisialisasi
  }

  Future<void> _getCurrentLocation() async {
    try {
      // meriksa kalo layanan lokasi diaktifkan
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _location = "Layanan lokasi dinonaktifkan.";
        });
        return;
      }

      // minta izin buat ngakses lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          setState(() {
            _location = "Izin lokasi ditolak.";
          });
          return;
        }
      }

      // ngambil info posisi sekarang
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // ngambil info placemarks dari koordinat
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      setState(() {
        _location =
            "${place.locality}, ${place.country}"; // ngatur lokasi kota dan negara
      });
    } catch (e) {
      setState(() {
        _location = "Gagal mendapatkan lokasi: $e";
      });
    }
  }

  Future<void> _refreshData() async {
    await _getCurrentLocation();
    await Future.delayed(Duration(seconds: 1));
  }

  List<Map<String, String>> _filterCoffeeItems(String category) {
    if (category == 'All') {
      return coffeeItems;
    } else {
      return coffeeItems.where((item) => item['category'] == category).toList();
    }
  }

  String getGreeting(String userName) {
    final hour = DateTime.now().hour; // nyari info jam

    if (hour < 12) {
      return "Hi $userName, Good Morning"; // Pagi
    } else if (hour < 17) {
      return "Hi $userName, Good Afternoon"; // Siang
    } else {
      return "Hi $userName, Good Evening"; // Malem
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder<String>(
                future: UserInfo().getUsername(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading user info'));
                  } else {
                    String userName = snapshot.data ?? 'User';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.green,
                              child: Text(
                                _getInitials(userName),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            // Info Lokasi
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined),
                                      const SizedBox(width: 5.0),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: _location.contains(',')
                                                  ? _location.split(',')[0]
                                                  : _location,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: _location.contains(',')
                                                  ? ', ${_location.split(',')[1]}'
                                                  : '',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        // Sapaan di bawah avatar
                        Text(
                          getGreeting(userName),
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Pencarian
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Search Menu...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        ValueListenableBuilder<String>(
                          valueListenable: _selectedCategoryNotifier,
                          builder: (context, selectedCategory, _) {
                            return CategorySelector(
                              onCategorySelected: (category) {
                                _selectedCategoryNotifier.value = category;
                              },
                              selectedCategory: selectedCategory,
                            );
                          },
                        ),
                        const SizedBox(height: 20.0),
                        ValueListenableBuilder<String>(
                          valueListenable: _selectedCategoryNotifier,
                          builder: (context, selectedCategory, _) {
                            final filteredItems =
                                _filterCoffeeItems(selectedCategory);

                            return CoffeeGrid(
                              key: ValueKey(selectedCategory),
                              coffeeItems: filteredItems,
                            );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi ngambil inisial dari nama user
  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    String initials = '';
    for (var part in nameParts) {
      initials += part[0];
    }
    return initials.toUpperCase();
  }
}

class CoffeeGrid extends StatelessWidget {
  final List<Map<String, String>> coffeeItems;

  const CoffeeGrid({Key? key, required this.coffeeItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return coffeeItems.isEmpty
        ? const Center(child: Text('Tidak ada item ditemukan di kategori ini.'))
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
              childAspectRatio: 3 / 4,
              mainAxisExtent: 200.0,
            ),
            itemCount: coffeeItems.length,
            itemBuilder: (context, index) {
              return CoffeeItem(
                name: coffeeItems[index]['name']!,
                imagePath: coffeeItems[index]['image']!,
                category: coffeeItems[index]['category']!,
              );
            },
          );
  }
}
