import 'dart:math';
import 'package:charts_flutter/flutter.dart';
import 'package:farreco/models/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farreco/models/soilParameters.dart';
import 'package:farreco/style.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as TextElement;
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:farreco/translation/translationConstants.dart';

class SQIGraph extends StatefulWidget {
  final uid;
  final List<DocumentSnapshot> documents;
  //instantiate uid
  SQIGraph({Key key, this.uid, this.documents}) : super(key: key);

  @override
  _SQIGraphState createState() =>
      _SQIGraphState(uid: uid, documents: documents);
}

class _SQIGraphState extends State<SQIGraph> {
  final uid;
  final List<DocumentSnapshot> documents;
  _SQIGraphState({this.uid, this.documents});
  @override
  Widget build(BuildContext context) {
    return _displayUserInformation(context, documents);
  }

  Widget _displayUserInformation(
      BuildContext context, List<DocumentSnapshot> documents) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return _buildChart(context, documents);
  }
}

//buildchart
Widget _buildChart(BuildContext context, documents) {
  List<charts.Series<SQITimeSeriesData, DateTime>> seriesData =
      _generateData(documents);
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            getTranslated(context, "sqiPageSQIGraphCurrentSQIText") +
                "${Utils().setSoilParameters(documents[documents.length - 1]).getSQI().toString()}",
            style: ListTileTitleTextStyle,
          ),
        ),
        Expanded(
            child: charts.TimeSeriesChart(
          seriesData,
          dateTimeFactory: const charts.LocalDateTimeFactory(),
          behaviors: [
            charts.LinePointHighlighter(
                symbolRenderer: CustomCircleSymbolRenderer())
          ],
          selectionModels: [
            SelectionModelConfig(changedListener: (SelectionModel model) {
              if (model.hasDatumSelection) {
                final value = model.selectedSeries[0]
                    .measureFn(model.selectedDatum[0].index);
                CustomCircleSymbolRenderer.value =
                    value; // paints the tapped value
              }
            })
          ],
        )),
        SizedBox(
          height: 10.0,
        ),
        Text(
          getTranslated(context, "sqiPageSQIGraphSQIByTimeText"),
          // 'SQI by time',
          style: ListTileTitleTextStyle,
        ),
      ],
    ),
  );
}

//create series of data
List<charts.Series<SQITimeSeriesData, DateTime>> _generateData(documents) {
  List<SQITimeSeriesData> data = [];
  for (var i = 0; i < documents.length; i++) {
    SoilParameters soilParameters = Utils().setSoilParameters(documents[i]);
    data.add(
        SQITimeSeriesData(soilParameters.getSQI(), soilParameters.createdTime));
  }
  return [
    new charts.Series<SQITimeSeriesData, DateTime>(
      id: 'SQI',
      colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      domainFn: (SQITimeSeriesData sqiData, _) => sqiData.createdTime,
      measureFn: (SQITimeSeriesData sqiData, _) => sqiData.sqi,
      data: data,
    )
  ];
}

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  static double value;

  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      Color fillColor,
      FillPatternType fillPattern,
      Color strokeColor,
      double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10,
            bounds.height + 10),
        fill: Color.white);
    var textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;
    canvas.drawText(TextElement.TextElement(value.toString(), style: textStyle),
        (bounds.left).round(), (bounds.top - 28).round());
  }
}

//time series data type
class SQITimeSeriesData {
  final double sqi;
  final DateTime createdTime;
  SQITimeSeriesData(this.sqi, this.createdTime);
}
