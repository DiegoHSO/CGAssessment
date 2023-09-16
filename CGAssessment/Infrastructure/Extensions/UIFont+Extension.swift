//
//  UIFont+Extension.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 14/09/23.
//

import UIKit

extension UIFont {

    static func compactDisplay(withStyle style: Style, size: CGFloat) -> UIFont {
        return UIFont(name: "SFCompactDisplay-\(style)", size: size) ?? .systemFont(ofSize: size)
    }

    static func compactRounded(withStyle style: Style, size: CGFloat) -> UIFont {
        return UIFont(name: "SFCompactRounded-\(style)", size: size) ?? .systemFont(ofSize: size)
    }
}

enum Style: String {
    case regular = "Regular"
    case medium = "Medium"
    case semibold = "Semibold"
    case bold = "Bold"
}
