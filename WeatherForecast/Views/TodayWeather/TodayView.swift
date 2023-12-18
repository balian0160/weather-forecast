//
//  TodayTab.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 26.09.2022.
//

import SwiftUI
import CoreLocation


struct TodayView: View {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let permissionString = "Please enable location permissions in settings."
    
    @EnvironmentObject var weatherManager: WeatherManagerVM
    
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
    @State private var showingUnitsOptions = false
    
    
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
                                showingUnitsOptions.toggle()
                            }
                            .confirmationDialog("Units", isPresented: $showingUnitsOptions, titleVisibility: .visible) {
                                Button("°C") {
                                    weatherManager.unitsString = "metric"
                                    weatherManager.requestLocation()
                                }
                                Button("°F") {
                                    weatherManager.unitsString = "imperial"
                                    weatherManager.requestLocation()
                                }
                            }
                            BottomIconsView(
                                humidity: humidityString,
                                precipitation: precipitationString,
                                pressure: pressureString,
                                windSpeed: windSpeedString,
                                windUnits: weatherManager.unitsStringWindUI,
                                windDirectionOutput: windDirectionOutputString,
                                isScreenSmall: screenWidth == 320
                            )
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
                if !weatherManager.weatherDataAvailable && weatherManager.locationAuthorized {
                    
                    weatherManager.requestLocation()
                }
            }
            .onChange(of: weatherManager.weather) { weather in
                updateWeatherData(with: weather)
            }
            .onChange(of: weatherManager.forecastList.first) { forecast in
                guard let forecast else {
                    return
                }
                self.precipitationString = forecast.precipitationString
            }
            .alert(isPresented: $weatherManager.fetchingError) {
                Alert(
                    title: Text("Wrong city name"),
                    message: Text("Please enter correct city name.")
                )
            }
        }
    }
    
    private func updateWeatherData(with weather: TodayWeatherModel) {
        self.temperatureString = weather.temperatureString
        self.conditionNameString = weather.conditionName
        self.cityName = weather.cityName
        self.stateName = weather.stateName
        self.humidityString = weather.humidityString
        self.windSpeedString = weather.windSpeedString
        self.windDirectionOutputString = weather.windDirectionOutputString
        self.pressureString = weather.pressureString
        self.weatherOutputTextString = weather.weatherOutputText
    }
}

struct TodayTab_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(WeatherManagerVM())
    }
}
