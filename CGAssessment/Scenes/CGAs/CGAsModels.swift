//
//  CGAsModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import UIKit

struct CGAsModels {

    struct CGAViewModel {
        let patientName: String?
        let lastEditedDate: Date
        let testsStatus: [CGADomainsModels.Domain: CompletionStatus]
    }

    enum CompletionStatus {
        case notStarted
        case incomplete
        case done

        var symbol: String {
            switch self {
            case .notStarted:
                "􁜣"
            case .incomplete:
                "􁜟"
            case .done:
                "􀁣"
            }
        }

        var color: UIColor? {
            switch self {
            case .notStarted:
                return .label3
            case .incomplete:
                return .label9
            case .done:
                return .label6
            }
        }
    }

}
