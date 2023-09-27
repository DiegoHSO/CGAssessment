//
//  SingleDomainRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 23/09/23.
//

import UIKit

protocol SingleDomainRoutingLogic {
    func routeToSingleTest(test: SingleDomainModels.Test)
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
    func routeToSingleTest(test: SingleDomainModels.Test) {
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
            break
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

    private func routeToTimedUpAndGoTest() {
        guard let timedUpAndGoController = TimedUpAndGoBuilder.build() else { return }

        viewController?.navigationController?.pushViewController(timedUpAndGoController, animated: true)
    }

    private func routeToWalkingSpeedTest() {
        guard let walkingSpeedController = WalkingSpeedBuilder.build() else { return }

        viewController?.navigationController?.pushViewController(walkingSpeedController, animated: true)
    }

    private func routeToCalfCircumferenceTest() {
        guard let calfCircumferenceController = CalfCircumferenceBuilder.build() else { return }

        viewController?.navigationController?.pushViewController(calfCircumferenceController, animated: true)
    }

    private func routeToGripStrengthTest() {
        guard let gripStrengthController = GripStrengthBuilder.build() else { return }

        viewController?.navigationController?.pushViewController(gripStrengthController, animated: true)
    }
}
