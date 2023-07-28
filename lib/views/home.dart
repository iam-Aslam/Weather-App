import 'package:flutter/material.dart';
import 'package:weatherapp/model/weather_model.dart';
import 'package:weatherapp/services/weather_api_client.dart';

import 'additional_information.dart';
import 'current_weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

TextEditingController editingController = TextEditingController();

class _HomePageState extends State<HomePage> {
  @override
  // ignore: override_on_non_overriding_member
  WeatherApiClient client = WeatherApiClient();
  Weather? data;
  String place = 'kochi';
  Future<void> getData(String place) async {
    data = await client.getCurrentWeather(place);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFf9f9f9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFf9f9f9),
          elevation: 0,
          title: const Text(
            "Weather App",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
            color: Colors.black,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onSubmitted: (value) {
                  setState(() {
                    place = value;
                  });
                },
                controller: editingController,
                decoration: const InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.clear),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            FutureBuilder(
              future: getData(place),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentWeather(Icons.wb_sunny_rounded, "${data!.temp}",
                          "${data!.cityName}"),
                      const SizedBox(
                        height: 60.0,
                      ),
                      const Text(
                        "Additional Information",
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Color(0xdd212121),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      additionalInformation(
                          "${data!.wind}",
                          "${data!.humidity}",
                          "${data!.pressure}",
                          "${data!.feelsLike}"),
                    ],
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
              },
            ),
          ],
        ));
  }
}
