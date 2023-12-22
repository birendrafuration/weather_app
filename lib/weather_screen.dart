import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/additional_info.dart';
import 'package:weather/weather_forecast.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=Mumbai&appid=0f922557949172e7345fef0a7722d1f8'));
      final data = jsonDecode(res.body);
      if (data["cod"] != "200") {
        throw "An expected Error occured!!";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather app",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => {setState(() => {})},
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (cotext, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final currentTemp = data['list'][0]['main']['temp'];
          final currentSky = data['list'][0]['weather'][0]['main'];
          final currentHumadity = data['list'][0]['main']['humidity'];
          final currentWindPressure = data['list'][0]['main']['pressure'];
          final currentWindSpeed = data['list'][0]['wind']['speed'];
          // final hourlyForecast = data['list'];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
             
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemp  ° K",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 56,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 15,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final horlySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hourlyTemp =
                          "${data['list'][index + 1]['main']['temp']}  ° F";
                      final horlyTime = data['list'][index + 1]['dt_txt'];
                      final time = DateTime.parse(horlyTime);
                      return HourlyForecastItem(
                        icon: horlySky == "Clouds" || horlySky == "Rain"
                            ? Icons.cloud
                            : Icons.sunny,
                        time: DateFormat.j().format(time),
                        temp: hourlyTemp,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionlaInformation(
                      icon: Icons.water_drop,
                      label: "Humadity",
                      valueText: '$currentHumadity',
                    ),
                    AdditionlaInformation(
                      icon: Icons.air,
                      label: "Wind Speed",
                      valueText: "$currentWindSpeed",
                    ),
                    AdditionlaInformation(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      valueText: '$currentWindPressure',
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
