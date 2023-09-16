//
//  SelectableKeys.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 14/09/23.
//

import Foundation

enum SelectableKeys: Int, Comparable {

    case none = 0
    case firstOption = 1
    case secondOption = 2
    case thirdOption = 3
    case fourthOption = 4

    static func < (lhs: SelectableKeys, rhs: SelectableKeys) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
