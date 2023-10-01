//
//  SingleDomainRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 23/09/23.
//

import UIKit

protocol SingleDomainRoutingLogic {
    func routeToSingleTest(test: SingleDomainModels.Test, cgaId: UUID?)
}

class SingleDomainRouter: SingleDomainRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    // swiftlint:disable:next cyclomatic_complexity
    func routeToSingleTest(test: SingleDomainModels.Test, cgaId: UUID?) {
        switch test {
        case .timedUpAndGo:
            routeToTimedUpAndGoTest(cgaId: cgaId)
        case .walkingSpeed:
            routeToWalkingSpeedTest(cgaId: cgaId)
        case .calfCircumference:
            routeToCalfCircumferenceTest(cgaId: cgaId)
        case .gripStrength:
            routeToGripStrengthTest(cgaId: cgaId)
        case .sarcopeniaAssessment:
            routeToSarcopeniaAssessment(cgaId: cgaId)
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

    // MARK: - Private Methods

    private func routeToTimedUpAndGoTest(cgaId: UUID?) {
        guard let timedUpAndGoController = TimedUpAndGoBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(timedUpAndGoController, animated: true)
    }

    private func routeToWalkingSpeedTest(cgaId: UUID?) {
        guard let walkingSpeedController = WalkingSpeedBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(walkingSpeedController, animated: true)
    }

    private func routeToCalfCircumferenceTest(cgaId: UUID?) {
        guard let calfCircumferenceController = CalfCircumferenceBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(calfCircumferenceController, animated: true)
    }

    private func routeToGripStrengthTest(cgaId: UUID?) {
        guard let gripStrengthController = GripStrengthBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(gripStrengthController, animated: true)
    }

    private func routeToSarcopeniaAssessment(cgaId: UUID?) {
        guard let sarcopeniaAssessmentController = SarcopeniaScreeningBuilder.build() else { return }

        viewController?.navigationController?.pushViewController(sarcopeniaAssessmentController, animated: true)
    }
}
