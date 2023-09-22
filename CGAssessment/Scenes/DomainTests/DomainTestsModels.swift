//
//  DomainTestsModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 22/09/23.
//

import Foundation

struct DomainTestsModels {

    struct TestViewModel {
        let title: String
        let description: String
        let status: TestStatus
    }

    enum TestStatus {
        case done
        case incomplete
        case notStarted

        var title: String {
            switch self {
            case .done:
                return LocalizedTable.done.localized
            case .incomplete:
                return LocalizedTable.incomplete.localized
            case .notStarted:
                return LocalizedTable.notStarted.localized
            }
        }

        var symbol: String {
            switch self {
            case .done:
                return "􀁣"
            case .incomplete:
                return "􀁝"
            case .notStarted:
                return "􀁡"
            }
        }
    }
}
