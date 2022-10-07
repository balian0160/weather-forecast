//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 27.09.2022.
//

import Foundation


struct WeatherModel {
    let conditionId: Int
    let citiName, stateName: String
    let temperature, pressure, humidity: Double
    let windSpeed, windDir: Double
    
    init() {
        self.conditionId = 0
        self.citiName = ""
        self.stateName = ""
        self.temperature = 0.0
        self.pressure = 0.0
        self.humidity = 0.0
        self.windSpeed = 0.0
        self.windDir = 0.0
    }
    
    init(conditionId: Int, citiName: String, stateName: String, temperature: Double, pressure: Double, humidity: Double, windSpeed: Double, windDir: Double) {
        self.conditionId = conditionId
        self.citiName = citiName
        self.stateName = stateName
        self.temperature = temperature
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDir = windDir
    }
    
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var humidityString: String {
        return String(format: "%.1f", humidity)
    }
    
    var pressureString: String {
        return String(format: "%.1f", pressure)
    }
    
    var windSpeedString: String {
        return String(format: "%.1f", windSpeed)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            //return "TodayThunderstorm"
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
            return "Watch out for lightning bolts"
        case Const.showers:
            return "Nice gentle shower"
        case Const.rain:
            return "It's raining"
        case Const.snow:
            return "It's snowing"
        case Const.mist:
            return "Visibility reduced"
        case Const.sun:
            return "It's sunny day"
        case Const.cloudy:
            return "The sky full of clouds"
        default:
            return "Indescribable weather"
        }
    }
    
    var windDirectionOutputString: String {
        
        let compassSector = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"]
        
        return compassSector[Int(round((windDir / 22.5)))]
    }
}
