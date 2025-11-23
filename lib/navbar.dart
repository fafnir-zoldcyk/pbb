import 'package:flutter/material.dart';
import 'package:flutter_application_1/cari.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/produk.dart';
import 'package:flutter_application_1/toko.dart';

class MainNavigation extends StatefulWidget {
  final String token;
  final int userId;
  final String username;
  final String nama;
  final List<dynamic> products; // ubah menjadi List

  const MainNavigation({
    super.key,
    required this.token,
    required this.userId,
    required this.username,
    required this.nama,
    required this.products,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomePage(
        userId: widget.userId,
        token: widget.token,
        username: widget.username,
        nama: widget.nama,
      ),
      ProdukPage(
        token: widget.token,
        userId: widget.userId, // pastikan ProdukPage menerima userId
      ),
      // SearchPage(products: widget.products),
      TokoPage(
        token: widget.token,
        userId: widget.userId,
        username: widget.username,
        nama: widget.nama,
      ),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: const Color.fromARGB(255, 56, 65, 57),
        unselectedItemColor: Colors.grey,
        onTap: (value) => setState(() => index = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: "Produk",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Cari",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory_rounded),
            label: "Toko",
          ),
        ],
      ),
    );
  }
}
