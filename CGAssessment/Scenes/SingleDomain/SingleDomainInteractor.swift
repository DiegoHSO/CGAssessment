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
    private var statusViewModel: CGAModels.StatusViewModel?

    // MARK: - Init

    init(presenter: SingleDomainPresentationLogic, domain: CGADomainsModels.Domain, worker: SingleDomainWorker, cgaId: UUID?) {
        self.presenter = presenter
        self.domain = domain
        self.cgaId = cgaId
        self.worker = worker
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        sendDataToPresenter()
    }

    func didSelect(test: SingleDomainModels.Test) {
        presenter?.route(toRoute: .domainTest(test: test, cgaId: cgaId))
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func computeViewModelData(tests: [Test]) {
        guard let cga = try? worker?.getCGA(with: cgaId) else { return }

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

        if tests.contains(.sarcopeniaScreening) {
            let sarcopeniaScreeningStatus = checkSarcopeniaScreeningStatus(cga: cga)
            let sarcopeniaAssessmentStatus = checkSarcopeniaAssessmentStatus(cga: cga)

            testsStatus.updateValue(sarcopeniaScreeningStatus == .done ? sarcopeniaAssessmentStatus : sarcopeniaScreeningStatus,
                                    forKey: .sarcopeniaScreening)
        }

        if tests.contains(.miniMentalStateExamination) {
            testsStatus.updateValue(checkMiniMentalStateExamStatus(cga: cga), forKey: .miniMentalStateExamination)
        }

        if tests.contains(.verbalFluencyTest) {
            testsStatus.updateValue(checkVerbalFluencyStatus(cga: cga), forKey: .verbalFluencyTest)
        }

        if tests.contains(.clockDrawingTest) {
            testsStatus.updateValue(checkClockDrawingStatus(cga: cga), forKey: .clockDrawingTest)
        }

        if tests.contains(.moca) {
            testsStatus.updateValue(checkMoCAStatus(cga: cga), forKey: .moca)
        }

        if tests.contains(.geriatricDepressionScale) {
            testsStatus.updateValue(checkGeriatricDepressionScaleStatus(cga: cga), forKey: .geriatricDepressionScale)
        }

        if tests.contains(.visualAcuityAssessment) {
            testsStatus.updateValue(checkVisualAcuityAssessmentStatus(cga: cga), forKey: .visualAcuityAssessment)
        }

        if tests.contains(.hearingLossAssessment) {
            testsStatus.updateValue(checkHearingLossAssessmentStatus(cga: cga), forKey: .hearingLossAssessment)
        }

        if tests.contains(.katzScale) {
            testsStatus.updateValue(checkKatzScaleStatus(cga: cga), forKey: .katzScale)
        }

        if tests.contains(.lawtonScale) {
            testsStatus.updateValue(checkLawtonScaleStatus(cga: cga), forKey: .lawtonScale)
        }

        if tests.contains(.miniNutritionalAssessment) {
            testsStatus.updateValue(checkMiniNutritionalAssessmentStatus(cga: cga), forKey: .miniNutritionalAssessment)
        }

        if tests.contains(.apgarScale) {
            testsStatus.updateValue(checkApgarScaleStatus(cga: cga), forKey: .apgarScale)
        }

        if tests.contains(.zaritScale) {
            testsStatus.updateValue(checkZaritScaleStatus(cga: cga), forKey: .zaritScale)
        }

        statusViewModel = .init(patientName: cga.patient?.name,
                                patientBirthDate: cga.patient?.birthDate,
                                cgaCreationDate: cga.creationDate ?? Date(),
                                cgaLastModifiedDate: cga.lastModification ?? Date())
    }

    private func createViewModel() -> SingleDomainModels.ControllerViewModel {
        var tests: [SingleDomainModels.Test] = []

        switch domain {
        case .mobility:
            tests = [.timedUpAndGo, .walkingSpeed, .calfCircumference,
                     .gripStrength, .sarcopeniaScreening]

        case .cognitive:
            tests = [.miniMentalStateExamination, .verbalFluencyTest,
                     .clockDrawingTest, .moca, .geriatricDepressionScale]
        case .sensory:
            tests = [.visualAcuityAssessment, .hearingLossAssessment]
        case .functional:
            tests = [.katzScale, .lawtonScale]
        case .nutritional:
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

        return SingleDomainModels.ControllerViewModel(domain: domain, tests: testsViewModel, statusViewModel: statusViewModel, sections: 1)
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

    private func checkSarcopeniaAssessmentStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.sarcopeniaAssessment?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkMiniMentalStateExamStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.miniMentalStateExam?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkVerbalFluencyStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.verbalFluency?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkClockDrawingStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.clockDrawing?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkMoCAStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.moCA?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkGeriatricDepressionScaleStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.geriatricDepressionScale?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkVisualAcuityAssessmentStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.visualAcuityAssessment?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkHearingLossAssessmentStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.hearingLossAssessment?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkKatzScaleStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.katzScale?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkLawtonScaleStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.lawtonScale?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkMiniNutritionalAssessmentStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.miniNutritionalAssessment?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkApgarScaleStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.apgarScale?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }

    private func checkZaritScaleStatus(cga: CGA) -> TestStatus {
        let status: TestStatus

        if let isDone = cga.zaritScale?.isDone {
            status = isDone ? .done : .incomplete
        } else {
            status = .notStarted
        }

        return status
    }
}
