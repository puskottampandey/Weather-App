import 'package:flutter/material.dart';
import 'package:weatherapp/screen/constant.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kcolor,
        centerTitle: true,
        title: const Text("Weather App"),
      ),
    );
  }
}
