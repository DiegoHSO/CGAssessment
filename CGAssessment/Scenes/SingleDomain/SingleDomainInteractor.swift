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

    private typealias Test = SingleDomainModels.Test
    private typealias TestStatus = SingleDomainModels.TestStatus
    private var presenter: SingleDomainPresentationLogic?
    private var worker: SingleDomainWorker?
    private var domain: CGADomainsModels.Domain
    private var cgaId: UUID?
    private var testsStatus: [Test: TestStatus] = [:]

    // MARK: - Init

    init(presenter: SingleDomainPresentationLogic, domain: CGADomainsModels.Domain, worker: SingleDomainWorker, cgaId: UUID?) {
        self.presenter = presenter
        self.domain = domain
        self.cgaId = cgaId
        self.worker = worker
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

    private func computeViewModelData(tests: [Test]) {
        guard let cgaId, let cga = try? worker?.getCGA(with: cgaId) else { return }

        if tests.contains(.timedUpAndGo) {
            testsStatus.updateValue(checkTimedUpAndGoStatus(cga: cga), forKey: .timedUpAndGo)
        }

        if tests.contains(.walkingSpeed) {
            testsStatus.updateValue(checkWalkingSpeedStatus(cga: cga), forKey: .walkingSpeed)
        }

        if tests.contains(.calfCircumference) {
            testsStatus.updateValue(checkCalfCircumferenceStatus(cga: cga), forKey: .calfCircumference)
        }

        if tests.contains(.gripStrength) {
            testsStatus.updateValue(checkGripStrengthStatus(cga: cga), forKey: .gripStrength)
        }

        if tests.contains(.sarcopeniaAssessment) {
            testsStatus.updateValue(checkSarcopeniaScreeningStatus(cga: cga), forKey: .sarcopeniaAssessment)
        }
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

        computeViewModelData(tests: tests)

        let testsViewModel = tests.map { SingleDomainModels.TestViewModel(test: $0,
                                                                          status: testsStatus[$0] ?? .done)
        }

        return SingleDomainModels.ControllerViewModel(domain: domain, tests: testsViewModel, sections: 1)
    }

    // MARK: - Tests Status Check

    private func checkTimedUpAndGoStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.timedUpAndGo?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkWalkingSpeedStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.walkingSpeed?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkCalfCircumferenceStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.calfCircumference?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkGripStrengthStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.gripStrength?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkSarcopeniaScreeningStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.sarcopeniaScreening?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }
}
