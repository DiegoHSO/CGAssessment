//
//  ResultsRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import UIKit

protocol ResultsRoutingLogic {
    func routeToNextTest(test: SingleDomainModels.Test)
    func routeBack(domain: CGADomainsModels.Domain)
    func routeToSarcopeniaAssessment()
}

class ResultsRouter: ResultsRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?
    private let cgaId: UUID?

    // MARK: - Init

    init(viewController: UIViewController, cgaId: UUID?) {
        self.viewController = viewController
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    // swiftlint:disable:next cyclomatic_complexity
    func routeToNextTest(test: SingleDomainModels.Test) {
        switch test {
        case .timedUpAndGo:
            routeToTimedUpAndGoTest()
        case .walkingSpeed:
            routeToWalkingSpeedTest()
        case .calfCircumference:
            routeToCalfCircumferenceTest()
        case .gripStrength:
            routeToGripStrengthTest()
        case .sarcopeniaAssessment:
            routeToSarcopeniaAssessment()
        case .miniMentalStateExamination:
            break
        case .verbalFluencyTest:
            break
        case .clockDrawingTest:
            break
        case .moca:
            break
        case .geriatricDepressionScale:
            break
        case .visualAcuityAssessment:
            break
        case .hearingLossAssessment:
            break
        case .katzScale:
            break
        case .lawtonScale:
            break
        case .miniNutritionalAssessment:
            break
        case .apgarScale:
            break
        case .zaritScale:
            break
        case .polypharmacyCriteria:
            break
        case .charlsonIndex:
            break
        case .suspectedAbuse:
            break
        case .cardiovascularRiskEstimation:
            break
        case .chemotherapyToxicityRisk:
            break
        }
    }

    func routeBack(domain: CGADomainsModels.Domain) {
        guard let singleDomainController = viewController?.navigationController?.viewControllers
                .first(where: { $0 is SingleDomainViewController }) as? SingleDomainViewController else { return }

        let presenter = SingleDomainPresenter(viewController: singleDomainController)
        let interactor = SingleDomainInteractor(presenter: presenter, domain: domain, worker: SingleDomainWorker(), cgaId: cgaId)
        let router = SingleDomainRouter(viewController: singleDomainController)

        singleDomainController.setupArchitecture(interactor: interactor, router: router)

        viewController?.navigationController?.popToViewController(singleDomainController, animated: true)
    }

    func routeToSarcopeniaAssessment() {
        guard let sarcopeniaAssessmentController = SarcopeniaAssessmentBuilder.build() else { return }

        viewController?.navigationController?.pushViewController(sarcopeniaAssessmentController, animated: true)
    }

    // MARK: - Private Methods

    private func routeToTimedUpAndGoTest() {
        guard let timedUpAndGoController = TimedUpAndGoBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(timedUpAndGoController, animated: true)
    }

    private func routeToWalkingSpeedTest() {
        guard let walkingSpeedController = WalkingSpeedBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(walkingSpeedController, animated: true)
    }

    private func routeToCalfCircumferenceTest() {
        guard let calfCircumferenceController = CalfCircumferenceBuilder.build() else { return }

        viewController?.navigationController?.pushViewController(calfCircumferenceController, animated: true)
    }

    private func routeToGripStrengthTest() {
        guard let gripStrengthController = GripStrengthBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(gripStrengthController, animated: true)
    }

    private func routeToSarcopeniaScreening() {
        guard let sarcopeniaScreeningController = SarcopeniaScreeningBuilder.build() else { return }

        viewController?.navigationController?.pushViewController(sarcopeniaScreeningController, animated: true)
    }
}
