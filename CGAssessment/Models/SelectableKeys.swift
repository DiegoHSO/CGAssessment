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

    static func < (lhs: SelectableKeys, rhs: SelectableKeys) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

@objc
enum SelectableBinaryOption: Int16, Comparable {
    case none = 0
    case yes
    case no
    
    static func < (lhs: SelectableBinaryOption, rhs: SelectableBinaryOption) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
