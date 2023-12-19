//
//  Font-Extensions.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 19.12.2023.
//

import Foundation
import SwiftUI


public extension Font {
    
    static let regularLabel = getRegularFont(ofSize: 14)
    static let bottomIconsTitle = getRegularFont(ofSize: 18)
    static let bottomIconsSubtitle = getRegularFont(ofSize: 14)
    
    static let temperatureTitle = getSemiboldFont(ofSize: 30)
    static let temperatureSubtitle = getLightFont(ofSize: 16)
    
    static func getRegularFont(ofSize: CGFloat) -> Font {
        return .system(size: ofSize, weight: .regular)
    }
    static func getSemiboldFont(ofSize: CGFloat) -> Font {
        return .system(size: ofSize, weight: .semibold)
    }
    static func getLightFont(ofSize: CGFloat) -> Font {
        return .system(size: ofSize, weight: .light)
    }
}
