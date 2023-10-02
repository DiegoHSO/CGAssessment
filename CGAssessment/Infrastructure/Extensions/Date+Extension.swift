//
//  Date+Extension.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 16/09/23.
//

import Foundation

extension Date {

    static func dateFromComponents(day: Int = 1, month: Int, year: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day],
                                                 from: Date())

        components.year = year
        components.month = month
        components.day = day

        return calendar.date(from: components) ?? Date()
    }

    func addingYear(_ quantity: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                 from: self)

        if let year = components.year {
            components.year = year + quantity
        }

        return calendar.date(from: components) ?? self
    }

    func addingMonth(_ quantity: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: quantity, to: self) ?? self
    }

    func removingTimeComponents() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components) ?? self
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var yearSinceCurrentDate: Int {
        let components = Calendar.current.dateComponents([.year], from: self, to: Date())
        return components.year ?? 0
    }

    var monthYearFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return dateFormatter.string(from: self)
    }
}
