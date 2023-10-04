//
//  String+Extension.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import Foundation

extension String {

    /// Compares the current string case insensitive with the given string
    /// - Parameter text: The string to be compared
    /// - Returns: True if the text is contained case insensitive in the current string, false otherwise
    func containsCaseInsensitive(_ text: String) -> Bool {
        return lowercased().contains(text.lowercased())
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
