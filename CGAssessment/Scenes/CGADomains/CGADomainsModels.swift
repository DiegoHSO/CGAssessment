//
//  CGADomainsModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 20/09/23.
//

import Foundation

struct CGADomainsModels {

    typealias Tests = [SingleDomainModels.Test: Bool]

    struct ControllerViewModel {
        let domains: [Domain: Tests]
        let statusViewModel: CGAModels.StatusViewModel?
    }

    struct DomainViewModel {
        let name: String
        let symbol: String
        let tests: Tests
    }

    struct TestViewModel {
        let name: String
        let isDone: Bool
    }

    enum Domain: Int, CaseIterable {
        case mobility = 0
        case cognitive
        case sensory
        case functional
        case nutricional
        case social
        case polypharmacy
        case comorbidity
        case other

        var title: String {
            switch self {
            case .mobility:
                return LocalizedTable.mobility.localized
            case .cognitive:
                return LocalizedTable.cognitive.localized
            case .sensory:
                return LocalizedTable.sensory.localized
            case .functional:
                return LocalizedTable.functional.localized
            case .nutricional:
                return LocalizedTable.nutricional.localized
            case .social:
                return LocalizedTable.social.localized
            case .polypharmacy:
                return LocalizedTable.polypharmacy.localized
            case .comorbidity:
                return LocalizedTable.comorbidity.localized
            case .other:
                return LocalizedTable.other.localized
            }
        }

        var symbol: String {
            switch self {
            case .mobility:
                return "􀵮"
            case .cognitive:
                return "􀯏"
            case .sensory:
                return "􀵣"
            case .functional:
                return "􁐑"
            case .nutricional:
                return "􁞲"
            case .social:
                return "􀝋"
            case .polypharmacy:
                return "􀠲"
            case .comorbidity:
                return "􀯚"
            case .other:
                return "􀜟"
            }
        }
    }

    enum Routing {
        case domainTests(domain: Domain, cgaId: UUID?)
    }
}
