import 'package:flutter/material.dart';

class KategoriPage extends StatelessWidget {
  const KategoriPage({super.key});

  final List<String> kategori = const [
    "Makanan",
    "Minuman",
    "Aksesoris",
    "Elektronik",
    "Fashion",
    "Alat Tulis",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: kategori.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, i) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                kategori[i],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
