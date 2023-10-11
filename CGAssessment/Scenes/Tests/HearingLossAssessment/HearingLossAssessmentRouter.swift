//
//  HearingLossAssessmentRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import UIKit

protocol HearingLossAssessmentRoutingLogic {
    func routeToKatzScaleTest(cgaId: UUID?)
}

class HearingLossAssessmentRouter: HearingLossAssessmentRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToKatzScaleTest(cgaId: UUID?) {
        /* TODO: Add Katz Scale routing
         viewController?.navigationController?.pushViewController(resultsController, animated: true)
         */
    }
}
