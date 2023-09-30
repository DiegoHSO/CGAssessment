//
//  DashboardModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import UIKit

struct DashboardModels {

    struct ViewModel {
        let latestEvaluation: LatestCGAViewModel?
        let todoEvaluations: [TodoEvaluationViewModel]

        var sections: [Section: [Row]] {
            let optionsForFirstSection: [Row] = [.recentApplication]
            let optionsForSecondSection: [Row] = [.menuOptions]
            var optionsForThirdSection: [Row] = []

            if !todoEvaluations.isEmpty {
                for _ in 1...todoEvaluations.count { optionsForThirdSection.append(.evaluationToReapply) }
            } else {
                optionsForThirdSection.append(.evaluationToReapply)
            }

            return [.recentEvaluation: optionsForFirstSection, .menuOptions: optionsForSecondSection,
                    .evaluationsToReapply: optionsForThirdSection]
        }
    }

    struct LatestCGAViewModel {
        let patientName: String
        let patientAge: Int
        let missingDomains: Int
    }

    struct TodoEvaluationViewModel {
        let patientName: String
        let patientAge: Int
        let alteredDomains: Int
        let nextApplicationDate: Date
        let lastApplicationDate: Date
    }

    enum Section: Int {
        case recentEvaluation = 0
        case menuOptions
        case evaluationsToReapply
    }

    enum Row {
        case recentApplication
        case menuOptions
        case evaluationToReapply
    }

    enum MenuOption {
        case cgaExample
        case lastCGA
        case newCGA
        case patients
        case cgaDomains
        case reports
        case evaluation(id: Int)
        case cgas
    }

    enum Routing {
        case cga(cgaId: Int)
        case newCGA
        case patients
        case cgaDomains
        case reports
        case cgas
    }
}
