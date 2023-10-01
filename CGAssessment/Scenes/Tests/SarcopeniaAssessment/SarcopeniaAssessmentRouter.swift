//
//  SarcopeniaAssessmentRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 28/09/23.
//

import UIKit

protocol SarcopeniaAssessmentRoutingLogic {
    func routeToTestResults(test: SingleDomainModels.Test, results: SarcopeniaAssessmentModels.TestResults)
    func routeToGripStrengthTest()
    func routeToCalfCircumferenceTest()
    func routeToTimedUpAndGoTest()
    func routeToWalkingSpeedTest()
}

class SarcopeniaAssessmentRouter: SarcopeniaAssessmentRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToTestResults(test: SingleDomainModels.Test, results: SarcopeniaAssessmentModels.TestResults) {
        guard let resultsController = ResultsBuilder.build(test: test, results: results, cgaId: nil) else { return }

        viewController?.navigationController?.pushViewController(resultsController, animated: true)
    }

    func routeToGripStrengthTest() {
        guard let gripStrengthController = GripStrengthBuilder.build(cgaId: nil) else { return }

        viewController?.navigationController?.pushViewController(gripStrengthController, animated: true)
    }

    func routeToCalfCircumferenceTest() {
        guard let calfCircumferenceController = CalfCircumferenceBuilder.build(cgaId: nil) else { return }

        viewController?.navigationController?.pushViewController(calfCircumferenceController, animated: true)
    }

    func routeToTimedUpAndGoTest() {
        guard let timedUpAndGoController = TimedUpAndGoBuilder.build(cgaId: nil) else { return } // TODO: Put CGA id

        viewController?.navigationController?.pushViewController(timedUpAndGoController, animated: true)
    }

    func routeToWalkingSpeedTest() {
        guard let walkingSpeedController = WalkingSpeedBuilder.build(cgaId: nil) else { return }

        viewController?.navigationController?.pushViewController(walkingSpeedController, animated: true)
    }
}
