//
//  CalfCircumferenceRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import UIKit

protocol CalfCircumferenceRoutingLogic {
    func routeToTestResults(test: SingleDomainModels.Test, results: CalfCircumferenceModels.TestResults)
}

class CalfCircumferenceRouter: CalfCircumferenceRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToTestResults(test: SingleDomainModels.Test, results: CalfCircumferenceModels.TestResults) {
        guard let resultsController = ResultsBuilder.build(test: test, results: results) else { return }

        viewController?.navigationController?.pushViewController(resultsController, animated: true)
    }
}