//
//  TimeInverval+Extension.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation

extension TimeInterval {

    var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1

        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number) ?? ""
        return formattedValue
    }

}
