//
//  CaseIterable+Extension.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }

    func back() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let previous = idx == all.startIndex ? all.index(all.endIndex, offsetBy: -1) : all.index(idx, offsetBy: -1)
        return all[previous]
    }
}
