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
        let id: UUID
    }

    struct TodoEvaluationViewModel {
        let patientName: String
        let patientAge: Int
        let alteredDomains: Int
        let nextApplicationDate: Date
        let lastApplicationDate: Date
        let id: UUID
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
        case evaluation(id: UUID?)
        case cgas
    }

    enum Routing: Equatable {
        case cga(cgaId: UUID?)
        case newCGA
        case patients
        case cgaDomains
        case reports
        case cgas
    }

    enum Number: Int {
        case one = 1
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten

        var unabbreviated: String {
            switch self {
            case .one:
                return LocalizedTable.one.localized
            case .two:
                return LocalizedTable.two.localized
            case .three:
                return LocalizedTable.three.localized
            case .four:
                return LocalizedTable.four.localized
            case .five:
                return LocalizedTable.five.localized
            case .six:
                return LocalizedTable.six.localized
            case .seven:
                return LocalizedTable.seven.localized
            case .eight:
                return LocalizedTable.eight.localized
            case .nine:
                return LocalizedTable.nine.localized
            case .ten:
                return LocalizedTable.ten.localized
            }
        }
    }
}
