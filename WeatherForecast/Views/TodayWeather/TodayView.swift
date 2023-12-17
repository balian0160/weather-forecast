//
//  TodayTab.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 26.09.2022.
//

import SwiftUI
import CoreLocation


struct TodayView: View, WeatherManagerDelegate {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let permissionString = "Please enable location permissions in settings."
    
    @EnvironmentObject var weatherManager: WeatherManager
    
    @ObservedObject var monitor = NetworkMonitor()
    
    @State var temperatureString: String = ""
    @State var conditionNameString: String = "sun.max.fill"
    @State var cityName: String = ""
    @State var stateName: String = ""
    @State var humidityString: String = ""
    @State var windSpeedString: String = ""
    @State var windDirectionOutputString: String = ""
    @State var pressureString: String = ""
    @State var weatherOutputTextString: String = ""
    @State var precipitationString: String = ""
    
    @State private var animationState = false
    @FocusState private var textFieldIsFocused: Bool
    
    
    // delegate method
    func didUpdateWeather() {
        updateWeatherData()
    }
    
    // delegate method, call if wrong city is entered
    func wrongCityEntered() {
        let alertController = UIAlertController(title: "Wrong city name", message: "Please enter correct city name.", preferredStyle: UIAlertController.Style.alert)
               
               
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let rootVC = window?.rootViewController ?? nil
        rootVC?.present(alertController, animated: true, completion: nil)
    }
    
    var body: some View {
        
        if !monitor.isConnected {
            NoConnectionView()
        } else {
            NavigationView {
                ZStack {
                    // background
                    VStack {
                        AnimatedBackground()
                        Spacer(minLength: screenHeight / 2)
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .ignoresSafeArea(.keyboard)
                    
                    // foreground
                    VStack(alignment: .center) {
                        Spacer()
                        HStack {
                            Spacer()
                            ShareButtonView(temperature: temperatureString, units: weatherManager.unitsStringUI)
                        }
                        // searchBarView // upper search bar
                        SearchBarView(
                            islocationAuthorized: weatherManager.locationAuthorized,
                            permissionString: permissionString,
                            onLocationClicked: weatherManager.requestLocation
                        ) { enteredCity in
                            weatherManager.fetchWeather(cityName: enteredCity)
                        }
                        Spacer()
                    
                        if weatherManager.weatherDataAvailable {
                            TemperatureView(
                                weatherInfoText: weatherOutputTextString,
                                conditionName: conditionNameString,
                                temperature: temperatureString,
                                units: weatherManager.unitsStringUI,
                                city: cityName,
                                state: stateName
                            )
                            .onLongPressGesture(minimumDuration: 2) {
                                print("Long pressed!")
                                
                                let alertController = UIAlertController(title: "Units", message: "Please select between °C and °F.", preferredStyle: UIAlertController.Style.alert)
                                
                                let CAction = UIAlertAction(title: "°C", style: .default, handler: { _ in
                                    // Redirect to Settings app
                                    weatherManager.unitsString = "metric"
                                    weatherManager.requestLocation()
                                })
                                
                                let FAction = UIAlertAction(title: "°F", style: .default, handler: { _ in
                                    // Redirect to Settings app
                                    weatherManager.unitsString = "imperial"
                                    weatherManager.requestLocation()
                                    
                                })
                                alertController.addAction(CAction)
                                alertController.addAction(FAction)
                                
                                let scenes = UIApplication.shared.connectedScenes
                                let windowScene = scenes.first as? UIWindowScene
                                let window = windowScene?.windows.first
                                let rootVC = window?.rootViewController ?? nil
                                rootVC?.present(alertController, animated: true, completion: nil)
                            }
                            
                            if screenWidth == 320 {
                                BottomIconsView(
                                    humidity: humidityString,
                                    precipitation: precipitationString,
                                    pressure: pressureString,
                                    windSpeed: windSpeedString,
                                    windUnits: weatherManager.unitsStringWindUI,
                                    windDirectionOutput: windDirectionOutputString,
                                    isScreenSmall: true
                                )
                            } else {
                                BottomIconsView(
                                    humidity: humidityString,
                                    precipitation: precipitationString,
                                    pressure: pressureString,
                                    windSpeed: windSpeedString,
                                    windUnits: weatherManager.unitsStringWindUI,
                                    windDirectionOutput: windDirectionOutputString
                                )
                            }
                        } else {
                            if weatherManager.locationAuthorized {
                                ActivityIndicator()
                                Text("Trying to get weather data")
                                    .font(.system(size: 20, weight: .regular))
                            } else {
                                EnableLocationView(
                                    islocationAuthorized: weatherManager.locationAuthorized,
                                    permissionString: permissionString
                                )
                            }
                            
                            Spacer()
                        }
                
                    } // end of foreground
                    .ignoresSafeArea(.keyboard)

                }
            }
            .onAppear {
                weatherManager.locationManager.requestWhenInUseAuthorization()
                weatherManager.delegate = self
                
                if !weatherManager.weatherDataAvailable && weatherManager.locationAuthorized {
                    
                    weatherManager.requestLocation()
                }
            }
        }
    }
    
    func updateWeatherData() {
        if weatherManager.forecastList.isEmpty {
            print("weatherManager.forecastList.isEmpty")
        } else {
            
            let weather = weatherManager.weather
            let forecast = weatherManager.forecastList[0]
            
            self.temperatureString = weather.temperatureString
            self.conditionNameString = weather.conditionName
            self.cityName = weather.cityName
            self.stateName = weather.stateName
            self.humidityString = weather.humidityString
            self.windSpeedString = weather.windSpeedString
            self.windDirectionOutputString = weather.windDirectionOutputString
            self.pressureString = weather.pressureString
            self.weatherOutputTextString = weather.weatherOutputText
            self.precipitationString = forecast.precipitationString
        }
    }
}

struct TodayTab_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(WeatherManager())
        // ContentView()
    }
}
