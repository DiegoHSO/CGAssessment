//
//  GripStrengthRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import UIKit

protocol GripStrengthRoutingLogic {
    func routeToTestResults(test: SingleDomainModels.Test, results: GripStrengthModels.TestResults, cgaId: UUID?)
}

class GripStrengthRouter: GripStrengthRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToTestResults(test: SingleDomainModels.Test, results: GripStrengthModels.TestResults, cgaId: UUID?) {
        let containsSarcopeniaController = viewController?.navigationController?.viewControllers
            .contains(where: { $0 is SarcopeniaAssessmentViewController }) ?? false

        guard let resultsController = ResultsBuilder.build(test: test, results: results, cgaId: cgaId,
                                                           isInSpecialFlow: containsSarcopeniaController) else { return }

        viewController?.navigationController?.pushViewController(resultsController, animated: true)
    }
}
