//
//  BinaryOptionsModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/10/23.
//

import Foundation

struct BinaryOptionsModels {

    struct BinaryOptionViewModel {
        let question: LocalizedTable
        let selectedOption: SelectableBinaryKeys
        let firstOptionTitle: String?
        let secondOptionTitle: String?
        let delegate: BinaryOptionDelegate?
        let sectionIdentifier: LocalizedTable?
        let identifier: Int
    }

    struct BinaryOptionsViewModel {
        let title: LocalizedTable?
        let questions: [Int: BinaryOption]
        let firstOptionTitle: String?
        let secondOptionTitle: String?
        let delegate: BinaryOptionDelegate?
        let leadingConstraint: CGFloat = 35
    }

    struct BinaryOption {
        let question: LocalizedTable
        let selectedOption: SelectableBinaryKeys
    }

}
