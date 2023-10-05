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
        let firstOptionTitle: String?
        let secondOptionTitle: String?
        let delegate: BinaryOptionDelegate?
    }
}
