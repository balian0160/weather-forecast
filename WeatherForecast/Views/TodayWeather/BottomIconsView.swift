//
//  BottomIconsView.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 17.12.2023.
//

import SwiftUI


struct BottomIconsView: View {
    
    private let humidity: String
    private let precipitation: String
    private let pressure: String
    private let windSpeed: String
    private let windUnits: String
    private let windDirectionOutput: String
    @State var isScreenSmall: Bool
    
    init(
        humidity: String,
        precipitation: String,
        pressure: String,
        windSpeed: String,
        windUnits: String,
        windDirectionOutput: String,
        isScreenSmall: Bool = false
    ) {
        self.humidity = humidity
        self.precipitation = precipitation
        self.pressure = pressure
        self.windSpeed = windSpeed
        self.windUnits = windUnits
        self.windDirectionOutput = windDirectionOutput
        self.isScreenSmall = isScreenSmall
    }
        
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .center) {
                VStack {
                    if !isScreenSmall {
                        Image(systemName: "humidity")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(.label))
                            .padding(8)
                            .background(Color("IconBackgroundColor"))
                            .cornerRadius(64)
                    }
                    
                    Text(humidity + " %")
                        .font(.system(size: 18, weight: .regular))
                    Text("Humidity")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("labelColor"))
                }
                .frame(width: iconWidth(), height: 90)
                
                VStack {
                    if !isScreenSmall {
                        Image(systemName: "drop")
                        // .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(.label))
                            .padding(8)
                            .background(Color("IconBackgroundColor"))
                            .cornerRadius(64)
                    }
                    
                    Text(precipitation + " MM")
                        .font(.system(size: 18, weight: .regular))
                    Text("Precipitation")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("labelColor"))
                }
                .frame(width: iconWidth(), height: 90)
                
                VStack {
                    if !isScreenSmall {
                        Image(systemName: "arrow.down")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(.label))
                            .padding(8)
                            .background(Color("IconBackgroundColor"))
                            .cornerRadius(64)
                    }
                    
                    
                    Text(pressure + " hPa")
                        .font(.system(size: 18, weight: .regular))
                    Text("Pressure")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("labelColor"))
                }
                .frame(width: iconWidth(), height: 90)
            }
            
            HStack {
                VStack {
                    if !isScreenSmall {
                        Image(systemName: "wind")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(.label))
                            .padding(8)
                            .background(Color("IconBackgroundColor"))
                            .cornerRadius(64)
                    }
                    
                    Text(windSpeed + windUnits)
                        .font(.system(size: 18, weight: .regular))
                    Text("Wind")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color("labelColor"))
                }
                .frame(width: iconWidth(), height: 90)
                
                VStack {
                    if !isScreenSmall {
                        Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(.label))
                            .padding(8)
                            .background(Color("IconBackgroundColor"))
                            .cornerRadius(64)
                    }
                    
                    Text(windDirectionOutput)
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
}

func iconWidth() -> CGFloat {
    return (UIScreen.main.bounds.width - 5 * 12) / 3
}

struct BottomIconsView_Previews: PreviewProvider {
    static var previews: some View {
        BottomIconsView(
            humidity: "80",
            precipitation: "3.2",
            pressure: "1017.0",
            windSpeed: "8.7",
            windUnits: "m/s",
            windDirectionOutput: "NE"
        )
    }
}
