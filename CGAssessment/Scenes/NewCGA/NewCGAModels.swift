//
//  NewCGAModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 16/09/23.
//

import Foundation

struct NewCGAModels {

    struct ControllerViewModel {
        let patients: [ResumedPatientViewModel]
        let selectedInternalOption: SelectableKeys
        let selectedExternalOption: SelectableKeys
        let patientName: String?
        let selectedPatient: Int
        let isDone: Bool
        let isSearching: Bool

        var sections: [Section: [Row]] {
            var optionsForFirstSection: [Row] = [.noOption, .pleaseFillIn, .name, .gender, .birthDate]
            let optionsForSecondSection: [Row] = [.yesOption, .searchBar]
            var numberOfPatients: [Row] = []

            if !patients.isEmpty {
                for _ in 1...patients.count { numberOfPatients.append(.patient) }
            }

            if isDone {
                optionsForFirstSection.append(.done)
                numberOfPatients.append(.done)
            }

            return [.newPatient: optionsForFirstSection, .existentPatient: optionsForSecondSection, .patients: numberOfPatients]
        }
    }

    struct ResumedPatientViewModel {
        let patient: Patient
        let id: Int
        let delegate: ResumedPatientDelegate?
        let isSelected: Bool
        var leadingConstraint: CGFloat = 30
    }

    struct Patient {
        let patientName: String
        let patientAge: Int
        let gender: Gender
    }

    struct PatientData {
        let patientName: String
        let birthDate: Date
        let gender: Gender
    }

    enum Section: Int {
        case newPatient = 0
        case existentPatient
        case patients
    }

    enum Row {
        case yesOption
        case searchBar
        case patient
        case noOption
        case pleaseFillIn
        case name
        case gender
        case birthDate
        case done
    }

    enum Routing {
        case cgaDomains
    }
}
