//
//  NSAttributedString+Extension.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 08/09/23.
//

import Foundation
import UIKit

extension NSAttributedString {
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: lhs)
        mutableAttributedString.append(rhs)
        return mutableAttributedString
    }

    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let multableAttributedString = NSMutableAttributedString(attributedString: lhs)
        multableAttributedString.append(rhs)
        lhs = multableAttributedString
    }
}

