import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/api-service.dart';
import 'package:flutter_application_1/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiServices apiService = ApiServices();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark Premium BG
      body: Stack(
        children: [
          // Glow effect background
          Positioned(
            top: -80,
            left: -50,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.25),
                shape: BoxShape.circle,
                // blurRadius: 90,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 65, 57, 66).withOpacity(0.15),
                shape: BoxShape.circle,
                // blurRadius: 80,
              ),
            ),
          ),

          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: _buildLoginForm(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.storefront_rounded,
          color: Colors.white,
          size: 80,
        ),
        const SizedBox(height: 12),
        const Text(
          "MarketPlace Sekolah",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 35),

        // Username
        _buildTextField(
          controller: emailController,
          label: "Username",
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),

        // Password Field
        ValueListenableBuilder<bool>(
          valueListenable: _isPasswordVisible,
          builder: (context, visible, _) {
            return _buildTextField(
              controller: passwordController,
              label: "Password",
              icon: Icons.lock_outline,
              obscure: !visible,
              suffixIcon: IconButton(
                icon: Icon(
                  visible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.white70,
                ),
                onPressed: () =>
                    _isPasswordVisible.value = !_isPasswordVisible.value,
              ),
            );
          },
        ),
        const SizedBox(height: 28),

        // Login Button
        ValueListenableBuilder<bool>(
          valueListenable: _isLoading,
          builder: (context, loading, _) {
            return SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: Colors.blueAccent.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: loading ? null : _handleLogin,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
              ),
            );
          },
        ),

        const SizedBox(height: 14),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Register",
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Custom TextField Dark Mode Premium
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    _isLoading.value = true;

    try {
      final result = await apiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final token = result["token"];
      final user = result["user"];

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Berhasil ✔")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            token: token,
            userId: user["id_user"],
            username: user["username"],
            nama: user["nama"],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _isLoading.value = false;
    }
  }
}
