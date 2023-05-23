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
      backgroundColor: kcolor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: wcolor),
        backgroundColor: kcolor,
        centerTitle: true,
        title: Text(
          "Weather App",
          style: TextStyle(color: wcolor),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: kcolor,
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
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 375,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 18),
                          child: TextFormField(
                            controller: textcoller,
                            onChanged: (value) {
                              updatebutton(value);
                            },
                            decoration: InputDecoration(
                              iconColor: wcolor,
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade400),
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
                    style: TextStyle(color: wcolor),
                  ),
                ),
              ),
              Container(
                color: Colors.indigo.shade700,
                child: FutureBuilder<Map<String, dynamic>>(
                  future: textcoller.text.trim().isEmpty
                      ? fetchWeatherData()
                      : futureWeatherData,
                  builder: ((context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final weatherdata = snapshot.data!;
                      return Container(
                        height: 600,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: kcolor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                weatherdata['location']['name'].toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: wcolor),
                              ),
                              Text(
                                weatherdata['current']['last_updated']
                                    .toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                weatherdata['location']['country'].toString(),
                                style: TextStyle(color: wcolor),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Image.network(
                                  "https:${weatherdata['current']['condition']['icon']}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  weatherdata['current']['condition']['text']
                                      .toString(),
                                  style: TextStyle(fontSize: 15, color: wcolor),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Today",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.indigo.shade700,
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Temp",
                                              style: TextStyle(
                                                  color: wcolor, fontSize: 14),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      25, 0, 10, 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    weatherdata['current']
                                                            ['temp_c']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: wcolor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "℃",
                                                    style: TextStyle(
                                                      color: wcolor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      height: 80,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.indigo.shade700,
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Wind",
                                              style: TextStyle(
                                                  color: wcolor, fontSize: 14),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 10, 20),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    weatherdata['current']
                                                            ['wind_kph']
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: wcolor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Km/h",
                                                    style: TextStyle(
                                                        fontSize: 6,
                                                        color: wcolor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      height: 80,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.indigo.shade700,
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Humidity",
                                              style: TextStyle(
                                                  color: wcolor, fontSize: 14),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      25, 0, 10, 20),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    weatherdata['current']
                                                            ['humidity']
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: wcolor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "%",
                                                    style: TextStyle(
                                                        color: wcolor),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("$snapshot.error");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        backgroundColor: kcolor,
                        color: wcolor,
                      );
                    } else {
                      return const Text("Nodata ");
                    }
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
