class SuggestionModel {
  double temperature, ph, humidity, rainfall;
  SuggestionModel(this.temperature, this.ph, this.humidity, this.rainfall);
  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'ph': ph,
        'humidity': humidity,
        'rainfall': rainfall
      };
}
