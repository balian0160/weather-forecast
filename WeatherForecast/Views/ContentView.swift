//
//  ContentView.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 26.09.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var weatherManager = WeatherManagerVM()
    @State private var selection: Tab = .today
    
    enum Tab {
        case today
        case forecast
    }
    
    init() {
        
        UITabBar.appearance().barTintColor = UIColor(named: "barTintColor")
        UITabBar.appearance().backgroundColor = UIColor(named: "barBackgroundColor")
    }
    
    var body: some View {
        
        TabView(selection: $selection) {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "paperplane")
                }
                .tag(Tab.today)

            ForecastView()
                .tabItem {
                    Label("Forecast", systemImage: "questionmark.square")
                }
                .tag(Tab.forecast)
        }
        .accentColor(Color("tabBarLabelColor"))
        .environmentObject(weatherManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .environmentObject(WeatherManagerVM())
            
    }
}
