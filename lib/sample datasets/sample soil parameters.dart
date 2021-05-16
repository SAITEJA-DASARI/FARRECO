import 'package:farreco/models/soilParameters.dart';

class SampleSoilParameters {
  static int i = 0;
  static List<SoilParameters> sampleData = [
    SoilParameters(13, 66, 5.8, i++),
    SoilParameters(12, 66, 5.8, i++),
    SoilParameters(13, 66, 5.8, i++),
    SoilParameters(14, 66, 5.8, i++),
    SoilParameters(15, 66, 5.8, i++),
    SoilParameters(16, 66, 5.8, i++),
    SoilParameters(17, 66, 5.8, i++),
    SoilParameters(17, 66, 5.8, i++),
    SoilParameters(18, 66, 5.8, i++),
    SoilParameters(19, 66, 5.8, i++),
    SoilParameters(18, 66, 5.8, i++),
    SoilParameters(19, 66, 5.8, i++),
    SoilParameters(19, 66, 5.8, i++),
    SoilParameters(12, 66, 5.8, i++),
    SoilParameters(12, 66, 5.8, i++),
    SoilParameters(13, 66, 5.8, i++),
    SoilParameters(14, 66, 5.8, i++),
    SoilParameters(14, 66, 5.8, i++),
    SoilParameters(12, 66, 5.8, i++),
    SoilParameters(14, 66, 5.8, i++),
    SoilParameters(14, 66, 5.8, i++),
  ];

  static List<SoilParameters> getSampleData() {
    return sampleData;
  }
}
