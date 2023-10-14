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
        let filterOptions: [CGAModels.FilterOptions]
        let selectedFilter: CGAModels.FilterOptions
        let patientName: String?

        var patientSections: [String]? { viewModelsByPatient?.keys.sorted() }
        var dateSections: [DateFilter]? {
            return viewModelsByDate?.keys.sorted(by: {
                if selectedFilter == .older {
                    ($0.month ?? 0) < ($1.month ?? 0) && ($0.year ?? 0) <= ($1.year ?? 0)
                } else {
                    ($0.month ?? 0) > ($1.month ?? 0) && ($0.year ?? 0) >= ($1.year ?? 0)
                }
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
        case newCGA
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
                return .label11
            case .notStarted:
                return .label9
            case .done:
                return .label3
            }
        }
    }

}
