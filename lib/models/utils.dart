import 'package:farreco/models/soilParameters.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

enum FarmingType { in_organic, semi_organic, organic }

class Utils {
  //set soil parameters to SoilParameters object
  SoilParameters setSoilParameters(document) {
    SoilParameters soilParameters =
        SoilParameters(0.0, 0.0, 0.0, DateTime.now());
    soilParameters.moisture = document['moisture'];
    soilParameters.pH = document['pH'];
    soilParameters.temperature = document['temperature'];
    soilParameters.createdTime = document['createdTime'].toDate();
    return soilParameters;
  }

//build list of GaugeRange of moisture
  List<GaugeRange> buildMoistureGaugeRangeList() {
    return <GaugeRange>[
      GaugeRange(startValue: 0, endValue: 10, color: Colors.red),
      GaugeRange(startValue: 10, endValue: 15, color: Colors.yellow),
      GaugeRange(startValue: 15, endValue: 18, color: Colors.green),
      GaugeRange(startValue: 18, endValue: 25, color: Colors.yellow),
      GaugeRange(startValue: 25, endValue: 100, color: Colors.red),
    ];
  }

//build list of GaugeRange of pH
  List<GaugeRange> buildPHGaugeRangeList() {
    return <GaugeRange>[
      GaugeRange(startValue: 0, endValue: 5.5, color: Colors.red),
      GaugeRange(startValue: 5.5, endValue: 7.2, color: Colors.green),
      GaugeRange(startValue: 7.2, endValue: 8.0, color: Colors.yellow),
      GaugeRange(startValue: 8.0, endValue: 14, color: Colors.red),
    ];
  }

  //build list of GaugeRange of temperature
  List<GaugeRange> buildTemperatureGaugeRangeList() {
    return <GaugeRange>[
      GaugeRange(startValue: 50, endValue: 65, color: Colors.red),
      GaugeRange(startValue: 65, endValue: 70, color: Colors.yellow),
      GaugeRange(startValue: 70, endValue: 80, color: Colors.green),
      GaugeRange(startValue: 80, endValue: 90, color: Colors.yellow),
      GaugeRange(startValue: 90, endValue: 110, color: Colors.red),
    ];
  }
}
