import 'dart:async'; // FIX: Timer import yang benar
import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _logoController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_logoController);

    _logoController.forward();

    // Timer to navigate
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, animation, __) => const LoginPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark splash
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.storefront_rounded,
                color: Colors.white,
                size: 90,
              ),
              SizedBox(height: 16),
              Text(
                "Marketplace Sekolah",
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
