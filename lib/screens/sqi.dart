import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farreco/models/soilParameters.dart';
import 'package:farreco/models/utils.dart';
import 'package:farreco/screens/signUp.dart';
import 'package:farreco/widgets/gaugeChart.dart';
import 'package:farreco/widgets/provider.dart';
import 'package:farreco/widgets/sqiGraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:farreco/style.dart';
import 'package:farreco/translation/translationConstants.dart';

class SQI extends StatelessWidget {
  //same widget will be used for generating sqi in connection section and sqi section
  final uid;

//constructor for sqi. pass the uid to the sqi widget to get the sqi values of that user
  SQI({
    Key key,
    this.uid,
  }) : super(key: key);

  //use StaggeredGridView to display time series sqi graph, ph gauge chart, moisture guage chart
  @override
  Widget build(BuildContext context) {
    //to get the height of the screen
    final _height = MediaQuery.of(context).size.height;
    //create a future to get all the soil parameters orderedby created time
    //these list of documents will be used in the entire sqi page
    //this way only one call is made to db
    return FutureBuilder(
      future: Provider.of(context).auth.getSoilParameters(context, uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            // <3> Retrieve `List<DocumentSnapshot>` from snapshot
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            return buildSQI(context, _height, documents);
          } else {
            return Text(
              getTranslated(context, "loadingSomethingWentWrongText"),
              // 'there is an Error!'
            );
          }
        } else {
          return Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                getTranslated(context, "loadingPleaseWaitText"),
                // "Please wait...",
                style: TextStyle(color: primaryColor, fontSize: 20),
              ),
              SizedBox(
                height: 20.0,
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              )
            ]),
          );
        }
      },
    );
  }

  Material buildSQI(
      BuildContext context, double _height, List<DocumentSnapshot> documents) {
    SoilParameters latestSoilParameters =
        Utils().setSoilParameters(documents[documents.length - 1]);
    return Material(
        //StaggeredGridView.count is used to divide the screen into grids
        child: StaggeredGridView.count(
      crossAxisCount: 2, //no of columns the screen is divided
      crossAxisSpacing: 20.0, //horizontal spacing between grids
      mainAxisSpacing: 16.0, //vertical spacing between grids
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      //children are the widgets inserted into each grid
      children: [
        buildGridTitles(
            getTranslated(context, "sqiPageSQITitleText"),
            // 'Soil Quality Index',
            Icons.bar_chart), //build title grids
        buildSQIGraph(documents), //build sqi graph
        buildGridTitles(
            getTranslated(context, "sqiPageSoilParametersText"),
            // 'Current soil parameters',
            Icons.speed),

        buildPHMeter(context, latestSoilParameters), //build ph gauge chart

        buildMoistureMeter(
            context, latestSoilParameters), //build moisture gauge chart

        buildTemperatureMeter(
            context, latestSoilParameters), //build temperature gauge chart
      ],
      staggeredTiles: [
        //satggered tile sizes are defined here
        StaggeredTile.extent(2, 0.05 * _height),
        StaggeredTile.extent(2, 0.5 * _height),
        StaggeredTile.extent(2, 0.1 * _height),
        StaggeredTile.extent(2, 0.6 * _height),
        StaggeredTile.extent(2, 0.6 * _height),
        StaggeredTile.extent(2, 0.6 * _height),
      ],
    ));
  }

  //moisture Gauge chart builder
  //get latest soil parameters document each time and set a soil parameters object with the fetched values
  //build gauge chart with the values
  Material buildMoistureMeter(
      BuildContext context, SoilParameters soilParameters) {
    return Material(
      color: Colors.white,
      elevation: 10.0,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(24.0),
      child: GaugeChart(
        gaugeRanges: Utils().buildMoistureGaugeRangeList(),
        minValue: 0,
        maxValue: 50,
        needleValue: soilParameters.moisture,
        intervalValue: 5,
        chartName: getTranslated(context, "sqiPageMoistureTitle"), //'Moisture',
      ),
    );
  }

  Material buildPHMeter(BuildContext context, SoilParameters soilParameters) {
    return Material(
      color: Colors.white,
      elevation: 10.0,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(24.0),
      child: GaugeChart(
        gaugeRanges: Utils().buildPHGaugeRangeList(),
        minValue: 0,
        maxValue: 14,
        needleValue: soilParameters.pH,
        intervalValue: 0.5,
        chartName: getTranslated(context, "sqiPagePhTitle"), //'pH',
      ),
    );
  }

  Material buildTemperatureMeter(
      BuildContext context, SoilParameters soilParameters) {
    return Material(
      color: Colors.white,
      elevation: 10.0,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(24.0),
      child: GaugeChart(
        gaugeRanges: Utils().buildTemperatureGaugeRangeList(),
        minValue: 50,
        maxValue: 110,
        needleValue: soilParameters.temperature,
        intervalValue: 5,
        chartName: getTranslated(
            context, "sqiPageTemperatureTitle"), //'temperature (\u00B0f) ',
      ),
    );
  }

  Material buildSQIGraph(List<DocumentSnapshot> documents) {
    return Material(
        color: Colors.white,
        elevation: 10.0,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(24.0),
        child: SQIGraph(
          uid: uid,
          documents: documents,
        ));
  }

  Material buildGridTitles(String title, IconData iconData) {
    return Material(
        color: primaryColor,
        elevation: 10.0,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: gridViewTitleTextStyle,
            ),
            SizedBox(
              width: 8.0,
            ),
            Icon(
              iconData,
              color: Colors.white,
            )
          ],
        ));
  }
}
