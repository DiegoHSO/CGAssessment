//
//  ZaritScaleRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 12/10/23.
//

import UIKit

protocol ZaritScaleRoutingLogic {
    func routeToTestResults(test: SingleDomainModels.Test, results: ZaritScaleModels.TestResults, cgaId: UUID?)
}

class ZaritScaleRouter: ZaritScaleRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToTestResults(test: SingleDomainModels.Test, results: ZaritScaleModels.TestResults, cgaId: UUID?) {
        guard let resultsController = ResultsBuilder.build(test: test, results: results, cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(resultsController, animated: true)
    }
}
