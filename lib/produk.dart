import 'package:flutter/material.dart';
import 'package:flutter_application_1/navbar.dart';

class ProdukPage extends StatefulWidget {
  final String token;
  final int userId; 
  const ProdukPage({super.key,required this.token,required this.userId});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child:GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 10, // nanti diganti API produk
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        color: Colors.grey[900],
                      ),
                      child: const Icon(Icons.image, color: Colors.white30, size: 40),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Nama Produk",
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Rp 10.000",
                        style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
  }
}
