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
        let externalOptions: Options
        let internalOptions: Options
        let pacientName: String?
        let selectedPacient: Int
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
        let pacientName: String
        let pacientAge: Int
        let gender: Gender
        let id: Int
        let delegate: ResumedPatientDelegate?
        let isSelected: Bool
        var leadingConstraint: CGFloat = 30
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
        case cgaParameters
    }
}
