//
//  BinaryOptionsModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/10/23.
//

import Foundation

struct BinaryOptionsModels {

    struct BinaryOptionViewModel {
        let question: String
        let firstOptionTitle: String?
        let secondOptionTitle: String?
        let delegate: BinaryOptionDelegate?
        let identifier: Int
    }

    struct BinaryOptionsViewModel {
        let title: String?
        let questions: [Int: LocalizedTable]
        let firstOptionTitle: String?
        let secondOptionTitle: String?
        let delegate: BinaryOptionDelegate?
        let leadingConstraint: CGFloat = 35
    }
}
