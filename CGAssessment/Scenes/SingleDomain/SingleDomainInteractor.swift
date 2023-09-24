//
//  SingleDomainInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 23/09/23.
//

import Foundation

protocol SingleDomainLogic: AnyObject {
    func controllerDidLoad()
    func didSelect(test: SingleDomainModels.Test)
}

class SingleDomainInteractor: SingleDomainLogic {

    // MARK: - Private Properties

    private var presenter: SingleDomainPresentationLogic?
    private var domain: CGADomainsModels.Domain

    // MARK: - Init

    init(presenter: SingleDomainPresentationLogic, domain: CGADomainsModels.Domain) {
        self.presenter = presenter
        self.domain = domain
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        // Not fully implemented
        sendDataToPresenter()
    }

    func didSelect(test: SingleDomainModels.Test) {
        presenter?.route(toRoute: .domainTest(test: test))
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> SingleDomainModels.ControllerViewModel {
        var tests: [SingleDomainModels.Test] = []

        switch domain {
        case .mobility:
            tests = [.timedUpAndGo, .walkingSpeed, .calfCircumference,
                     .gripStrength, .sarcopeniaAssessment]
        case .cognitive:
            tests = [.miniMentalStateExamination, .verbalFluencyTest,
                     .clockDrawingTest, .moca, .geriatricDepressionScale]
        case .sensory:
            tests = [.visualAcuityAssessment, .hearingLossAssessment]
        case .functional:
            tests = [.katzScale, .lawtonScale]
        case .nutricional:
            tests = [.miniNutritionalAssessment]
        case .social:
            tests = [.apgarScale, .zaritScale]
        case .polypharmacy:
            tests = [.polypharmacyCriteria]
        case .comorbidity:
            tests = [.charlsonIndex]
        case .other:
            tests = [.suspectedAbuse, .cardiovascularRiskEstimation, .chemotherapyToxicityRisk]
        }

        let testsViewModel = tests.map { SingleDomainModels.TestViewModel(test: $0,
                                                                          status: SingleDomainModels.TestStatus.allCases.randomElement()
                                                                            ?? .notStarted)
        }

        return SingleDomainModels.ControllerViewModel(domain: domain, tests: testsViewModel, sections: 1)
    }
}
