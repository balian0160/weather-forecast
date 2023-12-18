//
//  ForecastTab.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 26.09.2022.
//

import SwiftUI


struct ForecastView: View {
    
    @EnvironmentObject var weatherManager: WeatherManagerVM
    @ObservedObject var monitor = NetworkMonitor()
    
    let dayOfWeek = Date().dayNumberOfWeek()
    
    var body: some View {
        
        if !monitor.isConnected {
            NoConnectionView()
        } else {
            NavigationView {
                if weatherManager.weatherDataAvailable {
                    VStack {
                        HStack {
                            Spacer()
                              ForecastTableView()
                            Spacer()
                        }
                    }.navigationTitle("Forecast")
                        .font(.system(size: 22, weight: .bold))
                } else {
                    if !weatherManager.locationAuthorized {
                        Text("Search for data")
                    } else {
                        VStack {
                            ActivityIndicator()
                                .padding()
                            Text("Trying to get forecast data")
                                .font(.system(size: 20, weight: .regular))
                        }
                    }
                }
            }
        }
    }
}

struct ForecastTab_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
            .environmentObject(WeatherManagerVM())
    }
}
