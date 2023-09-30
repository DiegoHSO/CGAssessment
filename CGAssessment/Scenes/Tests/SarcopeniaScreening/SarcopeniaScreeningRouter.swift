//
//  SarcopeniaScreeningRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import UIKit

protocol SarcopeniaScreeningRoutingLogic {
    func routeToTestResults(test: SingleDomainModels.Test, results: SarcopeniaScreeningModels.TestResults)
}

class SarcopeniaScreeningRouter: SarcopeniaScreeningRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToTestResults(test: SingleDomainModels.Test, results: SarcopeniaScreeningModels.TestResults) {
        guard let resultsController = ResultsBuilder.build(test: test, results: results) else { return }

        viewController?.navigationController?.pushViewController(resultsController, animated: true)
    }
}
