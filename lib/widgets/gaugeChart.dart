import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:farreco/translation/translationConstants.dart';
import '../style.dart';

class GaugeChart extends StatefulWidget {
  final List<GaugeRange> gaugeRanges;
  final double minValue, maxValue, needleValue, intervalValue;
  final String chartName;
  GaugeChart(
      {Key key,
      this.gaugeRanges,
      this.minValue,
      this.maxValue,
      this.needleValue,
      this.intervalValue,
      this.chartName})
      : super(key: key);
  @override
  _GaugeChartState createState() => _GaugeChartState(
      gaugeRanges, minValue, maxValue, needleValue, intervalValue, chartName);
}

class _GaugeChartState extends State<GaugeChart> {
  List<GaugeRange> gaugeRanges;
  double minValue, maxValue, needleValue, intervalValue;
  String chartName;
  _GaugeChartState(this.gaugeRanges, this.minValue, this.maxValue,
      this.needleValue, this.intervalValue, this.chartName);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, bottom: 8.0, left: 5.0, right: 5.0),
            child: Text(
              getTranslated(context, "sqiPageCurrentParameterText") +
                  "$chartName: $needleValue",
              style: ListTileTitleTextStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Center(
                child: Container(
                    child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                    minimum: minValue,
                    maximum: maxValue,
                    ranges: gaugeRanges,
                    interval: intervalValue,
                    pointers: <GaugePointer>[
                      NeedlePointer(value: needleValue)
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Container(
                              child: Text('$needleValue',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold))),
                          angle: 90,
                          positionFactor: 0.5)
                    ]),
              ],
              enableLoadingAnimation: true,
            ))),
          ),
          Text(
            '$chartName ' +
                getTranslated(context, "sqiPageGaugeChartMeterText"),
            style: ListTileTitleTextStyle,
          ),
        ],
      ),
    );
  }
}
