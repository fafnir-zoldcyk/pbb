import 'package:flutter/material.dart';
import 'package:flutter_application_1/navbar.dart';

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  const SearchPage({super.key, required this.products});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  String selectedCategory = "All";
  List<String> categories = ["All"];

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(widget.products);

    for (var p in widget.products) {
      final cat = p["nama_kategori"];
      if (cat != null && !categories.contains(cat)) {
        categories.add(cat);
      }
    }
  }

  void filterProducts() {
    String search = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = widget.products.where((p) {
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
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFF111111),
          height: double.infinity,
          child: Column(
            children: [
              // Search Field
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => filterProducts(),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Cari produk...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Dropdown Kategori
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCategory,
                      dropdownColor: const Color(0xFF1A1A1A),
                      style: const TextStyle(color: Colors.white),
                      underline: Container(height: 0),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      items: categories
                          .map((cat) => DropdownMenuItem<String>(
                                value: cat,
                                child: Text(
                                  cat,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                          });
                          filterProducts();
                        }
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Hasil Pencarian
              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          "Tidak ada produk",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final item = filteredProducts[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: item["gambar"] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item["gambar"],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.image,
                                                    color: Colors.white38),
                                      ),
                                    )
                                  : const Icon(Icons.image, color: Colors.white38),
                              title: Text(
                                item["nama_produk"] ?? "",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                "Rp ${item["harga"]}",
                                style: const TextStyle(color: Colors.blueAccent),
                              ),
                              trailing: const Icon(Icons.chevron_right,
                                  color: Colors.white54),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
