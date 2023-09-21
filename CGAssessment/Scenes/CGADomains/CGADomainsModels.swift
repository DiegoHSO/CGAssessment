//
//  CGADomainsModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 20/09/23.
//

import Foundation

struct CGADomainsModels {

    struct ControllerViewModel {
        let domains: [Domain]
        let sections: Int
    }

    struct DomainViewModel {
        let name: String
        let symbol: String
        let tests: [TestViewModel]
    }

    struct TestViewModel {
        let name: String
        let isDone: Bool
    }

    enum Domain: Int {
        case mobility = 0
        case cognitive
        case sensory
        case functional
        case nutricional
        case social
        case polypharmacy
        case comorbidity
        case other

        var viewModel: DomainViewModel {
            switch self {
            case .mobility:
                return DomainViewModel(name: LocalizedTable.mobility.localized,
                                       symbol: "􀵮", tests: getTests())
            case .cognitive:
                return DomainViewModel(name: LocalizedTable.cognitive.localized,
                                       symbol: "􀯏", tests: getTests())
            case .sensory:
                return DomainViewModel(name: LocalizedTable.sensory.localized,
                                       symbol: "􀵣", tests: getTests())
            case .functional:
                return DomainViewModel(name: LocalizedTable.functional.localized,
                                       symbol: "􁐑", tests: getTests())
            case .nutricional:
                return DomainViewModel(name: LocalizedTable.nutricional.localized,
                                       symbol: "􁞲", tests: getTests())
            case .social:
                return DomainViewModel(name: LocalizedTable.social.localized,
                                       symbol: "􀝋", tests: getTests())
            case .polypharmacy:
                return DomainViewModel(name: LocalizedTable.polypharmacy.localized,
                                       symbol: "􀠲", tests: getTests())
            case .comorbidity:
                return DomainViewModel(name: LocalizedTable.comorbidity.localized,
                                       symbol: "􀯚", tests: getTests())
            case .other:
                return DomainViewModel(name: LocalizedTable.other.localized,
                                       symbol: "􀜟", tests: getTests())
            }
        }

        private func getTests() -> [TestViewModel] {
            switch self {
            case .mobility:
                return [.init(name: LocalizedTable.timedUpAndGo.localized, isDone: true),
                        .init(name: LocalizedTable.walkingSpeed.localized, isDone: false),
                        .init(name: LocalizedTable.calfCircumference.localized, isDone: false),
                        .init(name: LocalizedTable.gripStrength.localized, isDone: false),
                        .init(name: LocalizedTable.sarcopeniaAssessment.localized, isDone: false)]
            case .cognitive:
                return [.init(name: LocalizedTable.miniMentalStateExamination.localized, isDone: true),
                        .init(name: LocalizedTable.verbalFluencyTest.localized, isDone: false),
                        .init(name: LocalizedTable.clockDrawingTest.localized, isDone: false),
                        .init(name: LocalizedTable.moca.localized, isDone: false),
                        .init(name: LocalizedTable.geriatricDepressionScale.localized, isDone: false)]
            case .sensory:
                return [.init(name: LocalizedTable.visualAcuityAssessment.localized, isDone: true),
                        .init(name: LocalizedTable.hearingLossAssessment.localized, isDone: false)]
            case .functional:
                return [.init(name: LocalizedTable.katzScale.localized, isDone: true),
                        .init(name: LocalizedTable.lawtonScale.localized, isDone: false)]
            case .nutricional:
                return [.init(name: LocalizedTable.miniNutritionalAssessment.localized, isDone: true)]
            case .social:
                return [.init(name: LocalizedTable.apgarScale.localized, isDone: true),
                        .init(name: LocalizedTable.zaritScale.localized, isDone: true)]
            case .polypharmacy:
                return [.init(name: LocalizedTable.polypharmacyCriteria.localized, isDone: true)]
            case .comorbidity:
                return [.init(name: LocalizedTable.charlsonIndex.localized, isDone: true)]
            case .other:
                return [.init(name: LocalizedTable.suspectedAbuse.localized, isDone: true),
                        .init(name: LocalizedTable.cardiovascularRiskEstimation.localized, isDone: false),
                        .init(name: LocalizedTable.chemotherapyToxicityRisk.localized, isDone: false)]
            }
        }
    }

    enum Routing {
        case domainTests(domain: Domain)
    }
}
