//soil parameters model
class SoilParameters {
  DateTime createdTime;
  double moisture, temperature, pH, n, p, k;
  SoilParameters(this.moisture, this.temperature, this.pH, this.createdTime);
  Map<String, dynamic> toJson() => {
        'moisture': moisture,
        'temperature': temperature,
        'pH': pH,
        'createdTime': createdTime
      };

  double getSQI() {
    double sqi = 0;
    //calculate for moisture
    double moistureSQI = 0;
    if (moisture >= 10 && moisture < 15) {
      moistureSQI += 1;
    } else if (moisture >= 15 && moisture < 18) {
      moistureSQI += 2;
    } else if (moisture >= 18 && moisture < 25) {
      moistureSQI += 1;
    }

    // calculate for temperature
    double temperatureSQI = 0;
    if (temperature >= 65 && temperature < 70) {
      temperatureSQI += 1;
    } else if (temperature >= 70 && temperature < 80) {
      temperatureSQI += 2;
    } else if (temperature >= 80 && temperature < 90) {
      temperatureSQI += 1;
    }

    //calculate for pH
    double pHSQI = 0;
    if (pH >= 5.5 && pH < 7.2)
      pHSQI += 2;
    else if (pH >= 7.2 && pH < 8.0) pHSQI += 1;

    //calculate sqi
    sqi = 0.33 * moistureSQI + 0.33 * temperatureSQI + 0.33 * pHSQI;

    return sqi;
  }
}
