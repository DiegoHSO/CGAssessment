//
//  SarcopeniaAssessmentRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 28/09/23.
//

import UIKit

protocol SarcopeniaAssessmentRoutingLogic {
    func routeToTestResults(test: SingleDomainModels.Test, results: SarcopeniaAssessmentModels.TestResults, cgaId: UUID?)
    func routeToGripStrengthTest(cgaId: UUID?)
    func routeToCalfCircumferenceTest(cgaId: UUID?)
    func routeToTimedUpAndGoTest(cgaId: UUID?)
    func routeToWalkingSpeedTest(cgaId: UUID?)
}

class SarcopeniaAssessmentRouter: SarcopeniaAssessmentRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToTestResults(test: SingleDomainModels.Test, results: SarcopeniaAssessmentModels.TestResults, cgaId: UUID?) {
        guard let resultsController = ResultsBuilder.build(test: test, results: results, cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(resultsController, animated: true)
    }

    func routeToGripStrengthTest(cgaId: UUID?) {
        guard let gripStrengthController = GripStrengthBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(gripStrengthController, animated: true)
    }

    func routeToCalfCircumferenceTest(cgaId: UUID?) {
        guard let calfCircumferenceController = CalfCircumferenceBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(calfCircumferenceController, animated: true)
    }

    func routeToTimedUpAndGoTest(cgaId: UUID?) {
        guard let timedUpAndGoController = TimedUpAndGoBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(timedUpAndGoController, animated: true)
    }

    func routeToWalkingSpeedTest(cgaId: UUID?) {
        guard let walkingSpeedController = WalkingSpeedBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(walkingSpeedController, animated: true)
    }
}
