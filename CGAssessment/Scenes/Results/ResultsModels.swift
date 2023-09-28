//
//  ResultsModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import UIKit

struct ResultsModels {

    struct ViewModel {
        let testName: String
        let results: [Result]
        let resultType: ResultType

        var sections: [Section: [Row]] {
            var optionsForFirstSection: [Row] = [.results]
            let optionsForSecondSection: [Row] = [.nextTest, .goBack]

            if testName == LocalizedTable.sarcopeniaScreening.localized, resultType == .bad {
                optionsForFirstSection.append(.label)
            }

            return [.results: optionsForFirstSection,
                    .actionButtons: optionsForSecondSection]
        }
    }

    struct ResultsViewModel {
        let testName: String
        let results: [Result]
        let resultType: ResultType
    }

    struct Result {
        let title: String
        let description: String
    }

    enum ResultType {
        case excellent
        case good
        case medium
        case bad

        var color: UIColor? {
            switch self {
            case .excellent:
                .background16?.withAlphaComponent(0.43)
            case .good:
                .background17?.withAlphaComponent(0.43)
            case .medium:
                .background9
            case .bad:
                .background10
            }
        }
    }

    enum Routing {
        case nextTest(test: SingleDomainModels.Test)
        case routeBack(domain: CGADomainsModels.Domain)
        case sarcopeniaAssessment
    }

    enum Section: Int {
        case results = 0
        case actionButtons
    }

    enum Row {
        case results
        case nextTest
        case goBack
        case label
    }
}
