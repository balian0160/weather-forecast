//
//  ForecastWeatherData.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 27.09.2022.
//

import Foundation

struct ForecastWeatherData: Decodable {
    let list: [ForecastList]
}

struct ForecastList: Decodable {
    let main: ForecastMain
    let weather: [ForecastWeather]
    let rain: ForecastRain?
    let dt_txt: String
    
}

struct ForecastRain: Decodable {
    enum CodingKeys: String, CodingKey { case threeHours = "3h" }
    let threeHours: Double?
    
}

struct ForecastMain: Decodable {
    let temp: Double
}

struct ForecastWeather: Decodable {
    let id: Int
}
