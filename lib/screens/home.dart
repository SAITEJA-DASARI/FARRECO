import 'package:auto_size_text/auto_size_text.dart';
import 'package:farreco/translation/translationConstants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../style.dart';
import 'package:farreco/app.dart';
import 'package:farreco/translation/demoLocalization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);
  static void setLocale(BuildContext context, Locale locale) {
    _HomeState state = context.findAncestorStateOfType<_HomeState>();
    state.setLocale(locale);
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    if (this._locale == null) {
      return MaterialApp(
          home: Scaffold(
              body: Container(
        color: Colors.white,
      )));
    } else {
      //build a listview body
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //returns a container welcoming the user
                  buildWelcome(context),
                  SizedBox(
                    height: 5.0,
                  ),
                  //displays carousel slider
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 0.25 * _height,
                      viewportFraction: 0.9,
                      autoPlay: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      // enlargeCenterPage: true,
                      autoPlayAnimationDuration: Duration(seconds: 2),
                    ),
                    items: [
                      //function to build each slide
                      //takes 4 parameters
                      buildCarousalContainer(
                        getTranslated(context, "homePageSQICarouselTitleText"),
                        // "SQI",
                        getTranslated(
                            context, "homePageSQICarouselSubTitleText"),
                        // "(Soil Quality Index)",
                        getTranslated(
                            context, "homePageSQICarouselDescTitleText"),
                        // "Insights into Soil Quality",
                        getTranslated(
                            context, "homePageSQICarouselDescBodyText"),
                        // "Know about the trend of the soil quality over time",
                      ),
                      buildCarousalContainer(
                        getTranslated(
                            context, "homePageConnectCarouselTitleText"),
                        // "Connect",
                        getTranslated(
                            context, "homePageConnectCarouselSubTitleText"),
                        // "Connect with Farmers",
                        getTranslated(
                            context, "homePageConnectCarouselDescTitleText"),
                        // "Get Insights from farmers",
                        getTranslated(
                            context, "homePageConnectCarouselDescBodyText"),
                        // "Learn from other farmers about how to improve soil quality ",
                      ),
                      buildCarousalContainer(
                        getTranslated(
                            context, "homePageSuggestionCarouselTitleText"),
                        // "Suggestion",
                        getTranslated(
                            context, "homePageSuggestionCarouselSubTitleText"),
                        // "Crop Suggestion",
                        getTranslated(
                            context, "homePageSuggestionCarouselDescTitleText"),
                        // "Insights into best suited crops",
                        getTranslated(
                            context, "homePageSuggestionCarouselDescBodyText"),
                        // "Know which crop is best suited to your area using cimatic forecast",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  //function to build about us container
                  buildAboutContainer(context),
                ],
              ),
            ),
          ),
        ),
        locale: _locale,
        localizationsDelegates: [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', 'US'),
          Locale('te', 'IN'),
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (var supportedlocale in supportedLocales) {
            if (supportedlocale.languageCode == deviceLocale.languageCode) {
              return supportedlocale;
            }
          }
          return supportedLocales.first;
        },
      );
    }
  }

  Container buildAboutContainer(BuildContext context) {
    return Container(
      color: Colors.teal[900],
      padding: EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //function to build container with a title and description
          buildCustomContainer(
            getTranslated(context, "homePageAboutUsTitleText"),
            // "About us",
            getTranslated(context, "homePageAboutUsDescText"),
            // "We help farmers to monitor their soil health from time to time. We provide a network of farmers to learn various farming practices. We suggest best suited crop to your area using climatic forecast.
          ),
          SizedBox(
            height: 15.0,
          ),
          buildCustomContainer(
            getTranslated(context, "homepageContactUsTitleText"),
            // "Contact us",
            getTranslated(context, "homepageContactUsDescText"),
            // "Email : farreco@gmail.com \nPhone : 9876543210"
          ),
          SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }

  Container buildCustomContainer(String title, String body) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            title,
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 20,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8.0,
          ),
          AutoSizeText(
            body,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'arial',
              fontSize: 15.0,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Container buildCarousalContainer(
      String title, String subtitle, String descTitle, String descBody) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: AutoSizeText(
            title,
            style: ListTileTitleTextStyle,
            textAlign: TextAlign.center,
          )),
          Center(
              child: AutoSizeText(
            subtitle,
            style: ListTileSubTitleTextStyle,
            textAlign: TextAlign.center,
          )),
          SizedBox(
            height: 10.0,
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: AutoSizeText(
              descTitle,
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
          )),
          SizedBox(
            height: 5.0,
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: AutoSizeText(
              descBody,
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          )),
        ],
      ),
    );
  }

  Container buildWelcome(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0),
      decoration: BoxDecoration(
        color: Colors.transparent, //Colors.green[300],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                getTranslated(context, "homePageWelcomeText"),
                // "welcome to Farreco",
                style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              AutoSizeText(
                getTranslated(context, "homePageThankYouText"),
                // "Thank you for choosing farreco",
                style: Body1TextStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
