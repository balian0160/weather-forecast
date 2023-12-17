//
//  ForecastWeatherModel.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 27.09.2022.
//

import Foundation

struct ForecastWeatherModel {
    let conditionId: Int
    let temperature, precipitation: Double
    let dtText: String
    
    
    init() {
        self.conditionId = 0
        self.temperature = 0.0
        self.precipitation = 0.0
        self.dtText = ""
    }
    
    init(conditionId: Int, temperature: Double, precipitation: Double, dtText: String) {
        self.conditionId = conditionId
        self.temperature = temperature
        self.precipitation = precipitation
        self.dtText = dtText
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var precipitationString: String {
        return String(format: "%.1f", precipitation)
    }
    
    var timeString: String {
        let start = dtText.index(dtText.startIndex, offsetBy: 11)
        let end = dtText.index(dtText.endIndex, offsetBy: -3)
        let range = start..<end
        
        return String(dtText[range])
    }
    
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max.fill"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
    
    var weatherOutputText: String {
        switch conditionName {
        case Const.thunderstorm:
            return "Lightning bolts ahead"
        case Const.showers:
            return "Nice gentle shower"
        case Const.rain:
            return "It's raining"
        case Const.snow:
            return "It's snowing"
        case Const.mist:
            return "Visibility reduced"
        case Const.sun:
            return "It's a sunny day"
        case Const.cloudy:
            return "The sky full of clouds"
        default:
            return "Indescribable weather"
        }
    }
    
    
}
