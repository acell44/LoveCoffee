import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<Map<String, dynamic>> _menus = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _imageUrl;

  void _addMenu(BuildContext context) {
    _nameController.clear();
    _priceController.clear();
    _imageUrl = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Menu'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga Menu'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'URL Gambar'),
                onChanged: (value) {
                  _imageUrl = value;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _priceController.text.isNotEmpty) {
                    setState(() {
                      _menus.add({
                        'name': _nameController.text,
                        'price': _priceController.text,
                        'image': _imageUrl ?? '',
                      });
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Isi semua field')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 87, 34, 2),
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editMenu(BuildContext context, int index) {
    _nameController.text = _menus[index]['name'];
    _priceController.text = _menus[index]['price'];
    _imageUrl = _menus[index]['image'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Menu'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga Menu'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'URL Gambar'),
                onChanged: (value) {
                  _imageUrl = value;
                },
                controller: TextEditingController(text: _imageUrl),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _priceController.text.isNotEmpty) {
                    setState(() {
                      _menus[index] = {
                        'name': _nameController.text,
                        'price': _priceController.text,
                        'image': _imageUrl ?? '',
                      };
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Isi semua field')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 87, 34, 2),
                ),
                child: const Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteMenu(int index) {
    setState(() {
      _menus.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambahkan Menu Baru'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addMenu(context),
          ),
        ],
      ),
      body: _menus.isEmpty
          ? const Center(
              child: Text('Belum ada menu, tambahkan sekarang!'),
            )
          : ListView.builder(
              itemCount: _menus.length,
              itemBuilder: (context, index) {
                final menu = _menus[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: menu['image'] != null && menu['image']!.isNotEmpty
                        ? Image.network(
                            menu['image']!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                          )
                        : const Icon(Icons.local_cafe, size: 50),
                    title: Text(menu['name']),
                    subtitle: Text('Harga: ${menu['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Color.fromARGB(255, 87, 34, 2)),
                          onPressed: () => _editMenu(context, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMenu(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
