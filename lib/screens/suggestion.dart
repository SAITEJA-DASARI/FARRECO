import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farreco/models/soilParameters.dart';
import 'package:farreco/models/suggestionModel.dart';
import 'package:farreco/models/utils.dart';
import 'package:farreco/widgets/loading.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:weather/weather.dart';
import 'package:location/location.dart';
import 'package:farreco/screens/signUp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:farreco/translation/translationConstants.dart';
import '../style.dart';
import 'package:weather_icons/weather_icons.dart';

class Suggestion extends StatefulWidget {
  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  double latitude, longitude;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted;
  Location location = Location();
  LocationData _locationData;
  SuggestionModel suggestionModel = SuggestionModel(0, 0, 0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return Center(
                  child: Text(
                getTranslated(context, "suggestionPageAllowLocationText"),
                // "please allow location"
              ));
            } else {
              return buildWeatherData(context, snapshot.data);
            }
          } else {
            return FutureLoading(
              color: primaryColor,
            );
          }
        },
      ),
    );
  }

  Future<String> getSuggestion() async {
    final data = suggestionModel.toJson();
    final response = await http.post(
      Uri.parse('https://farmers-friend-api.herokuapp.com/api/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return "error";
    }
  }

  FutureBuilder buildWeatherData(
      BuildContext context, LocationData locationData) {
    double latitude = locationData.latitude, longitude = locationData.longitude;
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: getWeatherData(latitude, longitude),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<Weather> weather = snapshot.data;
            buildSuggestionModelBody(weather);
            var uid = Provider.of(context).auth.getCurrentUID();
            return Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Center(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    buildWeatherParameterUI(
                        "", weather[0].areaName, "", Icons.pin_drop),
                    SizedBox(
                      height: 10,
                    ),
                    buildWeatherParameterUI(
                        getTranslated(context, "suggestionPageRainfallText"),
                        // " Rainfall :",
                        suggestionModel.rainfall.toStringAsFixed(2),
                        // "cm",
                        getTranslated(
                            context, "suggestionPageRainfallUnitText"),
                        Icons.cloud),
                    SizedBox(
                      height: 8.0,
                    ),
                    buildWeatherParameterUI(
                        getTranslated(context, "suggestionPageTemperatureText"),
                        // " Temperature :",
                        suggestionModel.temperature.toStringAsFixed(2),
                        getTranslated(
                            context, "suggestionPageTemperatureUnitText"),
                        // "\u2103",
                        Icons.thermostat_outlined),
                    SizedBox(
                      height: 8.0,
                    ),
                    buildWeatherParameterUI(
                        getTranslated(context, "suggestionPageHumidityText"),
                        // " Humidity :",
                        suggestionModel.humidity.toStringAsFixed(2),
                        "%",
                        Icons.water_damage),
                    SizedBox(
                      height: 8.0,
                    ),
                    FutureBuilder(
                      future: Provider.of(context)
                          .auth
                          .getCurrentSoilParameteres(context, uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            final List<DocumentSnapshot> documents =
                                snapshot.data.docs;
                            SoilParameters soilParameters = Utils()
                                .setSoilParameters(
                                    documents[documents.length - 1]);
                            suggestionModel.ph = soilParameters.pH;
                            return buildWeatherParameterUI(
                                getTranslated(context, "suggestionPagePhText"),
                                // "pH",
                                suggestionModel.ph.toStringAsPrecision(2),
                                "",
                                Icons.speed);
                          } else {
                            return AutoSizeText(
                              getTranslated(
                                  context, "loadingSomethingWentWrongText"),
                              // "Something went wrong",
                              style: buildWeatherTextStyle(),
                            );
                          }
                        } else {
                          return Column(
                            children: [
                              SizedBox(
                                height: 20.0,
                              ),
                              FutureLoading(
                                color: primaryColor,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildSuggestion(),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                children: [
                  Text(
                    getTranslated(context, "loadingSomethingWentWrongText"),
                    // "Something went wrong!!"
                  )
                ],
              ),
            );
          }
        } else {
          return FutureLoading(
            color: primaryColor,
          );
        }
      },
    );
  }

  Center buildWeatherParameterUI(
      String title, String value, String units, IconData iconData) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 30.0,
            color: primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: AutoSizeText(
              title,
              style: buildWeatherTextStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              style: buildWeatherTextStyle(),
            ),
          ),
          AutoSizeText(
            units,
            style: buildWeatherTextStyle(),
          ),
        ],
      ),
    );
  }

  TextStyle buildWeatherTextStyle() {
    return TextStyle(
      color: primaryColor,
      fontFamily: 'serif',
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }

  FutureBuilder<String> buildSuggestion() {
    return FutureBuilder(
        future: getSuggestion(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var crop = snapshot.data;
            if (crop != "error") {
              return Container(
                padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Center(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AutoSizeText(
                        getTranslated(
                            context, "suggestionPageSuggestedCropText"),
                        // "Suggested crop to grow",
                        style: TextStyle(
                            color: primaryColor,
                            fontFamily: 'Times New Roman',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    AutoSizeText(
                      getTranslated(context, crop),
                      // crop,
                      style: TextStyle(
                        color: primaryColor,
                        fontFamily: 'serif',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
              );
            } else {
              return AutoSizeText(
                getTranslated(context, "loadingSomethingWentWrongText"),
                // "Something went wrong !!",
                style: buildWeatherTextStyle(),
              );
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Column(
            children: [
              SizedBox(height: 20),
              FutureLoading(color: primaryColor),
            ],
          );
        });
  }

  Future<List<Weather>> getWeatherData(
      double latitude, double longitude) async {
    WeatherFactory weatherFactory =
        new WeatherFactory("4b4c7028a29b57418250b69645d6bd1b");
    return await weatherFactory.fiveDayForecastByLocation(latitude, longitude);
  }

  void buildSuggestionModelBody(List<Weather> weather) async {
    final uid = Provider.of(context).auth.getCurrentUID();

    double temperature = 0, humidity = 0, rainfall = 0;

    print("length of weather data : ${weather.length}");

    //calculate average temperature, humidity, rainfall
    for (var i = 0; i < weather.length; i++) {
      temperature += weather[i].temperature.celsius;
      humidity += weather[i].humidity;
      if (weather[i].rainLast3Hours != null)
        rainfall += weather[i].rainLast3Hours;
    }
    temperature = temperature / weather.length;
    humidity = humidity / weather.length;
    rainfall = rainfall * 73 / weather.length;
    //TODO: convert  rainfall to cm
    // rainfall = rainfall / 10;
    //assign current pH

    print(
        "average weather parameters are \n temperature: $temperature \n humidity: $humidity \n rainfall: ${rainfall / 10} \n city: ${weather[0].areaName}");
    //return a SuggestionModel object with above parameters
    suggestionModel.temperature = temperature;
    suggestionModel.humidity = humidity;
    suggestionModel.rainfall = rainfall;
  }

  Future<LocationData> getCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("service not unabled");
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("not granted");
        return null;
      }
    }
    _locationData = await location.getLocation();
    latitude = _locationData.latitude;
    longitude = _locationData.longitude;

    print("location");
    print(latitude);
    print(longitude);
    return _locationData;
  }
}
