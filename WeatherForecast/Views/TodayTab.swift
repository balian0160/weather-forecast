//
//  TodayTab.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 26.09.2022.
//

import SwiftUI
import CoreLocation

struct NoConnectionView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .font(.system(size: 56))
            Text("Not connected!")
                .padding()
        }
    }
}


struct AnimatedBackground: View {
    @State var start = UnitPoint.bottom
    @State var end = UnitPoint.topLeading

    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors: [Color] = [.init("gradientStartColor"), .init("gradientMiddleColor1"), .init("gradientMiddleColor2"), .init("gradientEndColor")]

    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .animation(Animation.easeInOut(duration: 6).repeatForever(autoreverses: true), value: start)
            .onReceive(timer) { _ in
                 
                self.start = . bottomLeading
                self.end = .top
            }
            .edgesIgnoringSafeArea(.all)
    }
}


struct TodayTab: View, WeatherManagerDelegate {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let permissionString = "Please enable location permissions in settings."
    @State private var enteredCity: String = ""
    
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
                        shareButtonView
                        searchBarView // upper search bar
                        Spacer()
                    
                        if weatherManager.weatherDataAvailable {
                            tempInfoView // view with temperature
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
                                bottomIconsSmallView // bottom info without icons
                            } else {
                                bottomIconsView // bottom info with icons
                            }
                        } else {
                            if weatherManager.locationAuthorized {
                                ActivityIndicator()
                                Text("Trying to get weather data")
                                    .font(.system(size: 20, weight: .regular))
                            } else {
                                enableLocationView
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
    
    
    private var enableLocationView: some View {
        
        HStack {
            Spacer()
            Button {
                if !weatherManager.locationAuthorized {
                    let alertController = UIAlertController(title: "Location Permission Required", message: permissionString, preferredStyle: UIAlertController.Style.alert)
                           
                    let okAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                        // Redirect to Settings app
                        guard let url = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        UIApplication.shared.open(url)
                        
                    })
                           
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as? UIWindowScene
                    let window = windowScene?.windows.first
                    let rootVC = window?.rootViewController ?? nil
                    rootVC?.present(alertController, animated: true, completion: nil)
                }
            } label: {
                HStack {
                    Spacer()
                    Text("Enable location")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color("shareButtonTextColor"))
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(Color("shareButtonBackColor"))
                .cornerRadius(32)
                .shadow(radius: 15)
            }
            .frame(width: 135, height: 45)
            Spacer()
        }
    }
    
    private var shareButtonView: some View {
        HStack {
            Spacer()
            Button {
                let stringToShare = "Hey man! Have you heard about this app?"
                guard let url = URL(string: "https://www.google.com") else {
                    return }
                let stringToShare2 = "Btw, this is the temperature given by my new app:"
                let activityController = UIActivityViewController(activityItems: [stringToShare, url, stringToShare2, temperatureString + weatherManager.unitsStringUI], applicationActivities: nil)

                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                let rootVC = window?.rootViewController ?? nil
                rootVC?.present(activityController, animated: true, completion: nil)
                
            } label: {
                HStack {
                    Spacer()
                    Text("Share")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("shareButtonTextColor"))
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(Color("shareButtonBackColor"))
                .cornerRadius(32)
                .shadow(radius: 15)
                
            }
            .frame(width: 85, height: 45)
            .padding(.horizontal, 20)
        }
        
    }
    
    private var searchBarView: some View {
        HStack(alignment: .center, spacing: 8) {
            Spacer()
            
            Button {
                if !weatherManager.locationAuthorized {
                    let alertController = UIAlertController(title: "Location Permission Required", message: permissionString, preferredStyle: UIAlertController.Style.alert)
                           
                    let okAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                        // Redirect to Settings app
                        guard let url = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        UIApplication.shared.open(url)
                        
                    })
                           
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.first as? UIWindowScene
                    let window = windowScene?.windows.first
                    let rootVC = window?.rootViewController ?? nil
                    rootVC?.present(alertController, animated: true, completion: nil)
                    
                } else {
                    weatherManager.requestLocation()
                }
                
                withAnimation(.easeOut(duration: 3).repeatCount(3, autoreverses: true)) {
                    animationState.toggle()
                    
                }
            } label: {
                Image(systemName: "location.circle")
                    .font(.system(size: 32, weight: .light))
                    .rotationEffect(.degrees(animationState ? 360 : 0))
                    .scaleEffect(animationState ? 1.3 : 1)
                
            }
            
            TextField("Enter city", text: $enteredCity)
                .submitLabel(.search)
                .frame(width: 164, height: 32)
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
   
                .background(Color("SearchFieldColor"))
                .cornerRadius(8)
                .shadow(radius: 5)
                .focused($textFieldIsFocused)
                .onSubmit {
                    textFieldIsFocused = false
                    // fix for cities with whitepsace like San Francisco, New York etc.
                    enteredCity = enteredCity.split(separator: " ").joined(separator: "+")
                    weatherManager.fetchWeather(cityName: enteredCity)
                    enteredCity = ""
                }
            
            Spacer()
        }
    }
    
    private var tempInfoView: some View {
        VStack(alignment: .leading) {
            
            Text(weatherOutputTextString)
                .font(.system(size: 32, weight: .bold))
                .frame(width: screenWidth - 45, height: 80, alignment: .leading)
                .truncationMode(.tail)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            
            VStack(alignment: .leading) {
                Image(systemName: conditionNameString)
                    .font(.system(size: 40))
                    // .resizable()
                    .frame(width: 42, height: 42)
                    .foregroundColor(Color(.label))
                Text(temperatureString + weatherManager.unitsStringUI)
                    .font(.system(size: 30, weight: .semibold))
                Text(cityName + ", " + stateName)
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Color("labelColor"))
            }
        }
    }
        
    private var bottomIconsView: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .center) {
                VStack {
                    Image(systemName: "humidity")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(.label))
                        .padding(8)
                        .background(Color("IconBackgroundColor"))
                        .cornerRadius(64)
                    
                    Text(humidityString + " %")
                        .font(.system(size: 18, weight: .regular))
                    Text("Humidity")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("labelColor"))
                }
                .frame(width: iconWidth(), height: 90)
                
                VStack {
                    Image(systemName: "drop")
                        // .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(.label))
                        .padding(8)
                        .background(Color("IconBackgroundColor"))
                        .cornerRadius(64)
                    
                    
                    Text(precipitationString + " MM")
                        .font(.system(size: 18, weight: .regular))
                    Text("Precipitation")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("labelColor"))
                }
                .frame(width: iconWidth(), height: 90)
                
                VStack {
                    Image(systemName: "arrow.down")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(.label))
                        .padding(8)
                        .background(Color("IconBackgroundColor"))
                        .cornerRadius(64)
                    
                    Text(pressureString + " hPa")
                        .font(.system(size: 18, weight: .regular))
                    Text("Pressure")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("labelColor"))
                }
                .frame(width: iconWidth(), height: 90)
            }
            
            HStack {
                VStack {
                    Image(systemName: "wind")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(.label))
                        .padding(8)
                        .background(Color("IconBackgroundColor"))
                        .cornerRadius(64)
                    
                    
                    Text(windSpeedString + weatherManager.unitsStringWindUI)
                        .font(.system(size: 18, weight: .regular))
                    Text("Wind")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("labelColor"))
                }
                .frame(width: iconWidth(), height: 90)
                
                VStack {
                    Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(.label))
                        .padding(8)
                        .background(Color("IconBackgroundColor"))
                        .cornerRadius(64)
                    
                    Text(windDirectionOutputString)
                        .font(.system(size: 18, weight: .regular))
                    Text("Direction")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("labelColor"))
                }
                .frame(width: iconWidth(), height: 90)
            }
            
        }
        .padding(.vertical, 10)
    }
    
    private var bottomIconsSmallView: some View {
        
            VStack(alignment: .leading) {
                Spacer()
                
                HStack(alignment: .center, spacing: 10) {
                    VStack {
                        
                        Text(humidityString + " %")
                            .font(.system(size: 16, weight: .regular))
                        Text("Humidity")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color("labelColor"))
                    }
                    .frame(width: iconWidth(), height: 40)
                    
                    VStack {
                        
                        Text(precipitationString + " MM")
                            .font(.system(size: 16, weight: .regular))
                        Text("Precipitation")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color("labelColor"))
                    }
                    .frame(width: iconWidth(), height: 40)
                    
                    VStack {
                        Text(pressureString + " hPa")
                            .font(.system(size: 16, weight: .regular))
                        Text("Pressure")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color("labelColor"))
                    }
                    .frame(width: iconWidth(), height: 40)
                    
                }
                HStack(spacing: 10) {
                    VStack {
                        Text(windSpeedString + weatherManager.unitsStringWindUI)
                            .font(.system(size: 16, weight: .regular))
                        Text("Wind")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color("labelColor"))
                    }
                    .frame(width: iconWidth(), height: 40)
                    
                    VStack {
                        Text(windDirectionOutputString)
                            .font(.system(size: 16, weight: .regular))
                        Text("Direction")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color("labelColor"))
                    }
                    .frame(width: iconWidth(), height: 40)
                }
                .padding(.vertical, 15)
                
                Spacer()
            }
            .frame(minWidth: 320, maxHeight: 150, alignment: .center)
            .padding(.vertical, 1)
    }
        

    func iconWidth() -> CGFloat {
        return (UIScreen.main.bounds.width - 5 * 12) / 3
    }
    
    
    func updateWeatherData() {
        
            if weatherManager.forecastList.isEmpty {
                print("weatherManager.forecastList.isEmpty")
            } else {
            
                let weather = weatherManager.weather
                let forecast = weatherManager.forecastList[0]
        
                self.temperatureString = weather.temperatureString
                self.conditionNameString = weather.conditionName
                self.cityName = weather.citiName
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
        TodayTab()
            .environmentObject(WeatherManager())
        // ContentView()
    }
}
