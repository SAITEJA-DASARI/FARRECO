//soil parameters model
class SoilParameters {
  int createdTime;
  double moisture, temperature, pH, n, p, k;
  SoilParameters(this.moisture, this.temperature, this.pH, this.createdTime);
  Map<String, dynamic> toJson() => {
        'moisture': moisture,
        'temperature': temperature,
        'pH': pH,
        'createdTime': createdTime
      };
}
