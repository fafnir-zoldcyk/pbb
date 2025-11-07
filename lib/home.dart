import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String token;
  final int userId;
  const HomePage({super.key, required this.token, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}