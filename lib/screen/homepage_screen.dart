import 'package:flutter/material.dart';
import 'package:weatherapp/screen/constant.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final textcoller = TextEditingController();
  String buttontext = 'Save ';
  updatebutton() {
    setState(() {
      buttontext = textcoller.text.trim().isEmpty ? 'Save' : 'Update';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kcolor,
        centerTitle: true,
        title: const Text("Weather App"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 55,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.0,
                    blurRadius: 2,
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 375,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: textcoller,
                        onChanged: (value) {
                          updatebutton();
                        },
                        decoration: InputDecoration(
                          iconColor: kcolor,
                          suffixIcon: const Icon(Icons.search),
                          suffixIconColor: kcolor,
                          border: InputBorder.none,
                          hintText: "Search location....",
                          hintStyle: TextStyle(color: kcolor),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                if (textcoller.text.trim().isEmpty) {
                } else {}
              },
              child: Text(
                buttontext,
                style: TextStyle(color: kcolor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
