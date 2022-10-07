//
//  WeatherManager.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 27.09.2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather()
    
    func wrongCityEntered()
}

class WeatherManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=5c331da8830ced4813a92eea5d23c4d5"
    let forecastURL = "https://api.openweathermap.org/data/2.5/forecast?appid=5c331da8830ced4813a92eea5d23c4d5"
    
    @Published var weather = WeatherModel()
    @Published var forecastList = [ForecastWeatherModel]()
    @Published var forecastOffset: Int = 0
    @Published var weatherDataAvailable: Bool = false
    @Published var locationAuthorized: Bool = false
    @Published var fetchingError: Bool = false
    @Published var unitsString: String = "metric"
    @Published var unitsStringUI: String = " °C"
    @Published var unitsStringWindUI: String = " m/s"
    
    // location
    let locationManager = CLLocationManager()
    @Published var locationCoor: CLLocationCoordinate2D?
    @Published var locationFound: Bool = false
    
    var delegate: WeatherManagerDelegate?
    
    private var observation: NSKeyValueObservation?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func fetchWeather(cityName: String) {
        let weatherURLString = "\(weatherURL)&q=\(cityName)&units=\(unitsString)"
        let forecastURLString = "\(forecastURL)&q=\(cityName)&units=\(unitsString)"
        
        performRequest(weatherURLString: weatherURLString)
        performRequest(forecastURLString: forecastURLString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let weatherURLString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)&units=\(unitsString)"
        let forecastURLString = "\(forecastURL)&lat=\(latitude)&lon=\(longitude)&units=\(unitsString)"
        
        performRequest(weatherURLString: weatherURLString)
        performRequest(forecastURLString: forecastURLString)
    }
    
    func performRequest(weatherURLString: String) {
        
        if let url = URL(string: weatherURLString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    print(error ?? "")
                    return
                }
                DispatchQueue.main.async {
                    if let safeData = data {
                        if let returnedWeather = self.parseJSON(weatherData: safeData) {
                            self.weather = returnedWeather
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func performRequest(forecastURLString: String) {
        self.forecastList.removeAll()
        
        if let url = URL(string: forecastURLString) {
    
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                DispatchQueue.main.async {
                    if let safeData = data {
                        if let returnedForecast = self.parseJSON(forecastData: safeData) {
                            self.forecastList = returnedForecast
                            self.getForecastOffset()
                            self.weatherDataAvailable = true
                            
                            if self.unitsString == "metric" {
                                self.unitsStringUI = " °C"
                                self.unitsStringWindUI = " m/s"
                                
                            } else if self.unitsString == "imperial" {
                                self.unitsStringUI = " °F"
                                self.unitsStringWindUI = " m/h"
                            }
                            
                            self.delegate?.didUpdateWeather()
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(TodayWeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let cityName = decodedData.name
            let stateName = decodedData.sys.country
            let temp = decodedData.main.temp
            let humidity = decodedData.main.humidity
            let pressure = decodedData.main.pressure
            let windSpeed = decodedData.wind.speed
            let windDir = decodedData.wind.deg
            let weather = WeatherModel(conditionId: id, citiName: cityName, stateName: stateName, temperature: temp, pressure: pressure, humidity: humidity, windSpeed: windSpeed, windDir: windDir)
            return weather
        } catch {
            print(error)
            self.delegate?.wrongCityEntered()
            fetchingError = true
            return nil
        }
    }
    
    func parseJSON(forecastData: Data) -> [ForecastWeatherModel]? {
        let decoder = JSONDecoder()
        do {
            self.forecastList.removeAll()
            let decodedData = try decoder.decode(ForecastWeatherData.self, from: forecastData)
            // print("list size: " + String(decodedData.list.count))
            
            decodedData.list.forEach { forecastItem in
                let id = forecastItem.weather[0].id
                var precipitation = 0.0
                
                // rain item is not always available
                if let precipitationOpt = forecastItem.rain?.threeHours {
                    // rain exists
                    precipitation = precipitationOpt
                }
                
                let temp = forecastItem.main.temp
                let dtText = forecastItem.dt_txt
                
                self.forecastList.append(ForecastWeatherModel(conditionId: id, temperature: temp, precipitation: precipitation, dtText: dtText))
            }
            
            return self.forecastList
        } catch {
            print(error)
            fetchingError = true
            return nil
        }
    }
    
    func getForecastOffset() {
        let today = Date()
        var forecastDatesString: [String] = []
        var forecastDates: [Date] = []
        var daysOffset: Int = 0
    
        for forecastItem in forecastList {
    
            forecastDatesString.append(forecastItem.dtText)
            
            if let convertedDate = forecastItem.dtText.toDate(withFormat: "yyyy-MM-dd HH:mm:ss") {
                forecastDates.append(convertedDate)
            }
        }
        
        for forecastDate in forecastDates where today.isSame(.day, as: forecastDate) {
            daysOffset += 1
        }
        forecastOffset = daysOffset
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.locationFound.toggle()
                self.locationManager.stopUpdatingLocation()
                self.locationCoor = location.coordinate
                let latitude = self.locationCoor?.latitude ?? 0.0
                let longitude = self.locationCoor?.longitude ?? 0.0
                
                self.fetchWeather(latitude: latitude, longitude: longitude)
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authValue = Int(manager.authorizationStatus.rawValue.description)
        
        switch authValue {
        case 0, 1, 2:
            locationAuthorized = false
        case 3, 4:
            locationAuthorized = true
            requestLocation()
        default:
            locationAuthorized = false
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


extension String {

    func toDate(withFormat format: String) -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension Date {

    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func isSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
}
