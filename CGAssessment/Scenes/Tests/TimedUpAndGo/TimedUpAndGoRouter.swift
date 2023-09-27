//
//  TimedUpAndGoRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import UIKit

protocol TimedUpAndGoRoutingLogic {
    func routeToTestResults(test: SingleDomainModels.Test, results: TimedUpAndGoModels.TestResults)
}

class TimedUpAndGoRouter: TimedUpAndGoRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToTestResults(test: SingleDomainModels.Test, results: TimedUpAndGoModels.TestResults) {
        guard let resultsController = ResultsBuilder.build(test: test, results: results) else { return }

        viewController?.navigationController?.pushViewController(resultsController, animated: true)
    }
}
