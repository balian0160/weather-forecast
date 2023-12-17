//
//  String+Extensions.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 17.12.2023.
//

import Foundation


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
