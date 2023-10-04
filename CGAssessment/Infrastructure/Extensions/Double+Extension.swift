//
//  Double+Extension.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 25/09/23.
//

import Foundation

extension Double {

    func regionFormatted(fractionDigits: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = fractionDigits

        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number) ?? ""
        return formattedValue
    }

}
