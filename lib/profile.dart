import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';

class ProfilePage extends StatefulWidget {
  final String nama;
  final String username;
  final int userId;
  final String token;

  const ProfilePage({
    super.key,
    required this.nama,
    required this.userId,
    required this.token,
    required this.username,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Text(
                widget.username[0].toUpperCase(),
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              widget.nama,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Username: ${widget.username}",
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              "ID: ${widget.userId}",
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 25),

            // MENU
            _buildMenu(Icons.history, "Toko", () {
              // TODO: Navigasi ke riwayat pembelian
            }),
            _buildMenu(Icons.settings, "Produk", () {
              // TODO: Navigasi ke pengaturan
            }),
            _buildMenu(Icons.logout, "Logout", () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            color: Colors.white54, size: 18),
        onTap: onTap,
      ),
    );
  }
}
