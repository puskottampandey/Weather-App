import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:weatherapp/screen/constant.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var cityName = "";
  bool isloading = true;

  Future<Map<String, dynamic>>? futureWeatherData;

  Future<Map<String, dynamic>> fetchData(String cityName) async {
    var url = Uri.parse(
        "http://api.weatherapi.com/v1/current.json?key=$apiKey &q=$cityName");

    var response = await http.get(url);
    final weatherdata = jsonDecode(response.body);
    return weatherdata;
  }

  final textcoller = TextEditingController();
  String buttontext = 'Save ';
  updatebutton(value) {
    setState(() {
      buttontext = textcoller.text.trim().isEmpty ? 'Save' : 'Update';
      cityName = value;
    });
  }

  Future<Map<String, dynamic>> fetchWeatherData() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.granted) {}
    }
    locationData = await location.getLocation();
    double? lat = locationData.latitude;
    double? lon = locationData.longitude;

    var url = Uri.parse(
        "http://api.weatherapi.com/v1/current.json?key=$apiKey &q=$lat,$lon");
    var response = await http.get(url);
    final weatherdata = jsonDecode(response.body);
    return weatherdata;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kcolor,
        centerTitle: true,
        title: const Text("Weather App"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
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
                            updatebutton(value);
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
                  if (textcoller.text.trim().isNotEmpty) {
                    setState(() {
                      futureWeatherData = fetchData(textcoller.text);
                      isloading = false;
                    });
                  } else if (textcoller.text.trim().isEmpty) {}
                },
                child: Text(
                  buttontext,
                  style: TextStyle(color: kcolor),
                ),
              ),
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: textcoller.text.trim().isEmpty
                  ? fetchWeatherData()
                  : futureWeatherData,
              builder: ((context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  final weatherdata = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      height: 800,
                      width: MediaQuery.of(context).size.width * 0.9,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "City",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            Text(
                              weatherdata['location']['name'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            Text(weatherdata['location']['country'].toString()),
                            const SizedBox(
                              height: 50,
                            ),
                            const Text(
                              "Temperature",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            Row(
                              children: [
                                Text(
                                  weatherdata['current']['temp_c'].toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const Text(
                                  "℃",
                                ),
                              ],
                            ),
                            Text(
                              weatherdata['current']['condition']['text']
                                  .toString(),
                              style: const TextStyle(fontSize: 15),
                            ),
                            Center(
                              child: SizedBox(
                                height: 150,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Image.network(
                                  "https:${weatherdata['current']['condition']['icon']}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("$snapshot.error");
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text("Nodata ");
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
