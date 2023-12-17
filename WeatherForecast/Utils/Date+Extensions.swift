//
//  Date+Extensions.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 17.12.2023.
//

import Foundation


extension Date {
    func dayNumberOfWeek() -> Int? {
        // returns 1 - 7 int, with 1 being a Sunday
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func nextFiveDays(dayIndex: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: dayIndex, to: Date())
    }
    
    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func isSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
}
