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
        guard let katzScaleController = KatzScaleBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(katzScaleController, animated: true)

        if let viewController = viewController, let index = viewController.navigationController?.viewControllers.firstIndex(of: viewController) {
            viewController.navigationController?.viewControllers.remove(at: index)
        }
    }
}
