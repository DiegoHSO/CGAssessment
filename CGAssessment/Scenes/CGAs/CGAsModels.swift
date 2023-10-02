//
//  CGAsModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import UIKit

struct CGAsModels {

    typealias CGAsByPatient = [String: [CGAViewModel]]
    typealias CGAsByDate = [DateFilter: [CGAViewModel]]
    typealias DomainsStatus = [CGADomainsModels.Domain: CompletionStatus]

    struct ControllerViewModel {
        let viewModelsByPatient: CGAsByPatient?
        let viewModelsByDate: CGAsByDate?
        let filterOptions: [FilterOptions]
        let selectedFilter: FilterOptions

        var patientSections: [String]? { viewModelsByPatient?.keys.sorted() }
        var dateSections: [DateFilter]? {
            return viewModelsByDate?.keys.sorted(by: {
                selectedFilter == .older ? ($0.month ?? 0) < ($1.month ?? 0) && ($0.year ?? 0) < ($1.year ?? 0) :
                    ($0.month ?? 0) > ($1.month ?? 0) && ($0.year ?? 0) > ($1.year ?? 0)
            })
        }
    }

    struct CGAViewModel {
        let patientName: String?
        let lastEditedDate: Date
        let domainsStatus: DomainsStatus
        let cgaId: UUID?
    }

    struct DateFilter: Hashable {
        let month: Int?
        let year: Int?
    }

    enum Routing {
        case cgaDomains(cgaId: UUID?)
    }

    enum FilterOptions {
        case recent
        case older
        case byPatient

        var title: String? {
            switch self {
            case .recent:
                return LocalizedTable.recent.localized
            case .older:
                return LocalizedTable.older.localized
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
            case .incomplete:
                "􁜣"
            case .notStarted:
                "􁜟"
            case .done:
                "􀁣"
            }
        }

        var color: UIColor? {
            switch self {
            case .incomplete:
                return .label10
            case .notStarted:
                return .label9
            case .done:
                return .label3
            }
        }
    }

}
