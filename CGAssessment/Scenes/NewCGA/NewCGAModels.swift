//
//  NewCGAModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 16/09/23.
//

import Foundation

struct NewCGAModels {

    struct ResumedPatientViewModel {
        let pacientName: String
        let pacientAge: Int
        let gender: Gender
        let id: Int
        let delegate: ResumedPatientDelegate?
        let isSelected: Bool
    }
}
