//
//  SuspectedAbuseRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import UIKit

protocol SuspectedAbuseRoutingLogic {
    func routeToCardiovascularRisk(cgaId: UUID?)
}

class SuspectedAbuseRouter: SuspectedAbuseRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToCardiovascularRisk(cgaId: UUID?) {
        // TODO: Implement test
    }
}
