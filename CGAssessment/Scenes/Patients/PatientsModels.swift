//
//  PatientsModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 03/10/23.
//

import Foundation

struct PatientsModels {

    struct PatientViewModel {
        let name: String
        let birthDate: Date
        let hasCGAInProgress: Bool
        let lastCGADate: Date?
        let alteredDomains: Int
        let gender: Gender
    }

}
