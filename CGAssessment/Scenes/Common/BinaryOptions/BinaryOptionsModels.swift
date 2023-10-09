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
        let sectionIdentifier: LocalizedTable
        let identifier: Int16
    }

    struct BinaryOptionsViewModel {
        let title: LocalizedTable?
        var sectionIdentifier: LocalizedTable?
        let options: [Int16: SelectableBinaryKeys]
        let questions: [Int16: LocalizedTable]
        let firstOptionTitle: String?
        let secondOptionTitle: String?
        let delegate: BinaryOptionDelegate?
        var leadingConstraint: CGFloat = 35
        var bottomConstraint: CGFloat = 20
    }

}
