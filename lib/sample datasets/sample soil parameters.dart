import 'package:farreco/models/soilParameters.dart';

class SampleSoilParameters {
  static List<SoilParameters> sampleData = [
    SoilParameters(13, 66, 5.8, DateTime(2021, 5, 1).toUtc()),
    SoilParameters(12, 56, 6.1, DateTime(2021, 5, 2).toUtc()),
    SoilParameters(13, 59, 6.0, DateTime(2021, 5, 3).toUtc()),
    SoilParameters(14, 62, 6.1, DateTime(2021, 5, 4).toUtc()),
    SoilParameters(15, 64, 6.3, DateTime(2021, 5, 5).toUtc()),
    SoilParameters(16, 66, 6.8, DateTime(2021, 5, 6).toUtc()),
    SoilParameters(17, 70, 6.5, DateTime(2021, 5, 7).toUtc()),
    SoilParameters(17, 61, 6.4, DateTime(2021, 5, 8).toUtc()),
    SoilParameters(18, 63, 6.6, DateTime(2021, 5, 9).toUtc()),
    SoilParameters(19, 67, 6.7, DateTime(2021, 5, 10).toUtc()),
    SoilParameters(18, 71, 6.8, DateTime(2021, 5, 11).toUtc()),
    SoilParameters(19, 73, 6.8, DateTime(2021, 5, 12).toUtc()),
    SoilParameters(19, 74, 6.9, DateTime(2021, 5, 13).toUtc()),
    SoilParameters(12, 71, 7.2, DateTime(2021, 5, 14).toUtc()),
    SoilParameters(12, 73, 7.3, DateTime(2021, 5, 15).toUtc()),
    SoilParameters(13, 69, 7.4, DateTime(2021, 5, 16).toUtc()),
    SoilParameters(14, 70, 6.7, DateTime(2021, 5, 17).toUtc()),
    SoilParameters(14, 72, 6.8, DateTime(2021, 5, 18).toUtc()),
    SoilParameters(12, 74, 6.9, DateTime(2021, 5, 19).toUtc()),
    SoilParameters(16, 76, 7.0, DateTime(2021, 5, 20).toUtc()),
    SoilParameters(17, 78, 7.1, DateTime(2021, 5, 21).toUtc()),
  ];

  static List<SoilParameters> getSampleData() {
    return sampleData;
  }
}
