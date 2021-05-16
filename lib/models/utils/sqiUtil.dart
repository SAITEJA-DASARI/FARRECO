class SQIUtil { 
  double calculateSqi(double temperature, double moisture, double pH) {
    double sqi = 0;
    //calculate for moisture
    double moistureSQI=0;
    if(moisture>=10 && moisture<15)moistureSQI+=1;
    else if(moisture>=15 && moisture<18)moistureSQI+=2;
    else if(moisture>=18 && moisture<25)moistureSQI+=1;

    // calculate for temperature
    double temperatureSQI=0;
    if(temperature>=65 && temperature<70)temperatureSQI+=1;
    else if(temperature>=70 && temperature<80)temperatureSQI+=2;
    else if(temperature>=80 && temperature<90)temperatureSQI+=1;

    //calculate for pH
    double pHSQI=0;
    if(pH>=5.5 and pH<7.2)pHSQI+=2;
    else if(pH>=7.2 and pH<8.0)pHSQI+=1;
    
    //calculate sqi
    sqi = 0.33*moistureSQI + 0.33*temperatureSQI + 0.33*pHSQI;
    return sqi;
  }
}
