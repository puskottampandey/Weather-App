import 'package:flutter/material.dart';

class Weekweather extends StatelessWidget {
  final Future<Map<String, dynamic>>? data;
  const Weekweather({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("puskottam"),
      ),
    );
  }
}
