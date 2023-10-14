//
//  PatientsModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 03/10/23.
//

import Foundation

struct PatientsModels {

    struct ControllerViewModel {
        var patients: [PatientViewModel]
        let filterOptions: [CGAModels.FilterOptions]
        let selectedFilter: CGAModels.FilterOptions
        let isSearching: Bool

        var sections: [Section: [Row]] {
            let optionsForFirstSection: [Row] = [.searchBar, .filter]
            var numberOfPatients: [Row] = []

            if !patients.isEmpty {
                for _ in 1...patients.count { numberOfPatients.append(.patient) }
            } else {
                numberOfPatients.append(.patient)
            }

            return [.searchAndFilter: optionsForFirstSection, .patients: numberOfPatients]
        }
    }

    struct PatientViewModel {
        let name: String
        let birthDate: Date
        let hasCGAInProgress: Bool
        let lastCGADate: Date?
        let alteredDomains: Int
        let gender: Gender
        let patientId: UUID?
    }

    enum Routing {
        case cgas(patientId: UUID?)
        case newCGA
    }

    enum Section: Int {
        case searchAndFilter
        case patients
    }

    enum Row {
        case searchBar
        case filter
        case patient
    }

}
