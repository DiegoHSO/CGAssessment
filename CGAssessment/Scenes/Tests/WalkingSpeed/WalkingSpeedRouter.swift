//
//  WalkingSpeedRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import UIKit

protocol WalkingSpeedRoutingLogic {
    func routeToTestResults(test: SingleDomainModels.Test, results: WalkingSpeedModels.TestResults, cgaId: UUID?)
}

class WalkingSpeedRouter: WalkingSpeedRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToTestResults(test: SingleDomainModels.Test, results: WalkingSpeedModels.TestResults, cgaId: UUID?) {
        guard let resultsController = ResultsBuilder.build(test: test,
                                                           results: results, cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(resultsController, animated: true)
    }
}
