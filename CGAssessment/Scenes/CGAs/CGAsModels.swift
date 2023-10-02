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

    enum FilterOptions {
        case recent
        case older
        case all
        case byPatient

        var title: String? {
            switch self {
            case .recent:
                return LocalizedTable.recent.localized
            case .older:
                return LocalizedTable.older.localized
            case .all:
                return LocalizedTable.all.localized
            case .byPatient:
                return LocalizedTable.byPatient.localized
            }
        }
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
