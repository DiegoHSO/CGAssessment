//
//  SelectableKeys.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 14/09/23.
//

import Foundation

@objc
enum SelectableKeys: Int16, Comparable {
    case none = 0
    case firstOption = 1
    case secondOption = 2
    case thirdOption = 3
    case fourthOption = 4
    case fifthOption = 5
    case sixthOption = 6
    case seventhOption = 7
    case eighthOption = 8
    case ninthOption = 9
    case tenthOption = 10
    case eleventhOption = 11
    case twelfthOption = 12
    case thirteenthOption = 13
    case fourteenthOption = 14
    case fifteenthOption = 15
    case sixteenthOption = 16

    static func < (lhs: SelectableKeys, rhs: SelectableKeys) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

@objc
enum SelectableBinaryKeys: Int16, Comparable {
    case none = 0
    case yes
    case not

    static func < (lhs: SelectableBinaryKeys, rhs: SelectableBinaryKeys) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
