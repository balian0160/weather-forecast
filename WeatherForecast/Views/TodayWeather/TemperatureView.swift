//
//  TemperatureView.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 17.12.2023.
//

import SwiftUI


struct TemperatureView: View {
    
    private let weatherInfoText: String
    private let conditionName: String
    private let temperature: String
    private let units: String
    private let city: String
    private let state: String
    
    init(weatherInfoText: String, conditionName: String, temperature: String, units: String, city: String, state: String) {
        self.weatherInfoText = weatherInfoText
        self.conditionName = conditionName
        self.temperature = temperature
        self.units = units
        self.city = city
        self.state = state
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(weatherInfoText)
                .font(.system(size: 32, weight: .bold))
                .frame(width: UIScreen.main.bounds.size.width - 45, height: 80, alignment: .leading)
                .truncationMode(.tail)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            
            VStack(alignment: .leading) {
                Image(systemName: conditionName)
                    .font(.system(size: 40))
                    // .resizable()
                    .frame(width: 42, height: 42)
                    .foregroundColor(.labelColor)
                Text(temperature + units)
                    .font(.temperatureTitle)
                Text(city + ", " + state)
                    .font(.temperatureSubtitle)
                    .foregroundColor(.labelColor)
            }
        }
    }
}

struct TemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureView(
            weatherInfoText: "It's sunny day",
            conditionName: "sun.max.fill",
            temperature: "24.5",
            units: "C",
            city: "Prague",
            state: "CZ"
        )
    }
}
