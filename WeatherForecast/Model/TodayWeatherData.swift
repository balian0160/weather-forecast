//
//  TodayWeatherData.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 27.09.2022.
//

import Foundation

struct TodayWeatherData: Decodable {
    let name: String
    let sys: Country
    let main: Main
    let weather: [Weather]
    let wind: Wind
}


struct Main: Decodable {
    let temp: Double
    let pressure: Double
    let humidity: Double
}

struct Weather: Decodable {
    let id: Int
}

struct Wind: Decodable {
    let speed: Double
    let deg: Double
}

struct Country: Decodable {
    let country: String
}
