//
//  VisualAcuityAssessmentRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 10/10/23.
//

import UIKit

protocol VisualAcuityAssessmentRoutingLogic {
    func routeToTestResults(test: SingleDomainModels.Test, results: VisualAcuityAssessmentModels.TestResults, cgaId: UUID?)
}

class VisualAcuityAssessmentRouter: VisualAcuityAssessmentRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToTestResults(test: SingleDomainModels.Test, results: VisualAcuityAssessmentModels.TestResults, cgaId: UUID?) {
        guard let resultsController = ResultsBuilder.build(test: test, results: results, cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(resultsController, animated: true)
    }
}
