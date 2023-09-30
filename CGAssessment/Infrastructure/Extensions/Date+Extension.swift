//
//  Date+Extension.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 16/09/23.
//

import Foundation

extension Date {

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

    var year: Int {
        let components = Calendar.current.dateComponents([.year], from: self)
        return components.year ?? 0
    }
}
