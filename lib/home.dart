import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String token;
  final int userId;
  final String username;
  final String nama;

  const HomePage({
    super.key,
    required this.token,
    required this.userId,
    required this.username,
    required this.nama,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List products = [];
  List filteredProducts = [];
  List<String> categories = [];
  String selectedCategory = "All";
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse("http://learncode.biz.id/api/products"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        products = data["data"];
        filteredProducts = List.from(products);

        categories = ["All"];
        for (var p in products) {
          if (p["nama_kategori"] != null &&
              !categories.contains(p["nama_kategori"])) {
            categories.add(p["nama_kategori"]);
          }
        }

        setState(() => isLoading = false);
      } else {
        throw Exception("Gagal memuat produk");
      }
    } catch (e) {
      print("ERROR FETCHING PRODUCTS: $e");
      setState(() => isLoading = false);
    }
  }

  void filterProducts() {
    String search = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((p) {
        final name = (p["nama_produk"] ?? "").toLowerCase();
        final category = (p["nama_kategori"] ?? "");
        bool matchCategory =
            selectedCategory == "All" || category == selectedCategory;
        bool matchSearch = name.contains(search);
        return matchCategory && matchSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hanya kembalikan konten, Scaffold di MainNavigation
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Halo, ${widget.username}",
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            onChanged: (_) => filterProducts(),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              hintText: "Cari produk...",
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: selectedCategory,
            dropdownColor: const Color(0xFF1A1A1A),
            style: const TextStyle(color: Colors.white),
            underline: Container(),
            items: categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedCategory = value);
                filterProducts();
              }
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  )
                : filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          "Tidak ada produk",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : GridView.builder(
                        itemCount: filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemBuilder: (_, index) {
                          final item = filteredProducts[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 120,
                                  width: double.infinity,
                                  color: Colors.grey[900],
                                  child: item["gambar"] != null
                                      ? Image.network(item["gambar"],
                                          fit: BoxFit.cover)
                                      : const Icon(Icons.image,
                                          color: Colors.white38, size: 48),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item["nama_produk"] ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Rp ${item["harga"] ?? 0}",
                                    style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
