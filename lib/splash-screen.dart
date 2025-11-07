import 'dart:nativewrappers/_internal/vm/lib/async_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
  with SingleTickerProviderStateMixin{
    late AnimationController _logoContoller;
    late Animation<double> _fadeAnimation;

  @override
  void initState(){
    super.initState();

    _logoContoller =
     AnimationController(vsync: this, duration: const Duration(seconds: 2));
     _fadeAnimation = 
     Tween<double>(begin: 0.0, end: 1.0).animate(_logoContoller);

     _logoContoller.forward();

     Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(PageRouteBuilder(transitionDuration: const Duration(microseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
          );
      },
      ));
     });
  }

  @override 
  void dispose(){
    _logoContoller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold();
  }
  }
