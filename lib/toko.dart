import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TokoPage extends StatefulWidget {
  final String token;
  final int userId;
  final String username;
  final String nama;
  final String? avatarUrl;

  const TokoPage({
    super.key,
    required this.token,
    required this.userId,
    required this.username,
    required this.nama,
    this.avatarUrl,
  });

  @override
  State<TokoPage> createState() => _TokoPageState();
}

class _TokoPageState extends State<TokoPage> {
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

        setState(() {
          isLoading = false;
        });
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
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Toko Sekolah",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Halo username
            Center(
              child: Text(
                "Halo, ${widget.username}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Search bar
            TextField(
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
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            // Dropdown kategori
            DropdownButton<String>(
              value: selectedCategory,
              dropdownColor: const Color(0xFF1A1A1A),
              style: const TextStyle(color: Colors.white),
              underline: Container(height: 0),
              items: categories
                  .map((cat) => DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat),
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
            const SizedBox(height: 16),
            // Grid produk
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    )
                  : filteredProducts.isEmpty
                      ? const Center(
                          child: Text(
                            "Tidak ada produk",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final item = filteredProducts[index];
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color(0xFF1A1A1A),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 120,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(14)),
                                      color: Colors.grey[900],
                                    ),
                                    child: item["gambar"] != null &&
                                            item["gambar"].toString().isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(14)),
                                            child: Image.network(
                                              item["gambar"],
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons.image,
                                              color: Colors.white38,
                                              size: 48,
                                            ),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item["nama_produk"] ?? "Produk",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      "Rp ${item["harga"]}",
                                      style: const TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w600),
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
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1A1A1A),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            accountName: Text(widget.username,
                style: const TextStyle(color: Colors.white)),
            accountEmail: Text("Nama: ${widget.nama}",
                style: const TextStyle(color: Colors.white70)),
            currentAccountPicture: widget.avatarUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(widget.avatarUrl!),
                    backgroundColor: Colors.blueAccent,
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, color: Colors.white, size: 38),
                  ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text("Profile", style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text("Logout", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
