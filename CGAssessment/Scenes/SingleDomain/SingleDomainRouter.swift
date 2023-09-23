//
//  SingleDomainRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 23/09/23.
//

import UIKit

protocol SingleDomainRoutingLogic {
    func routeToSingleTest(test: SingleDomainModels.Test)
}

class SingleDomainRouter: SingleDomainRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToSingleTest(test: SingleDomainModels.Test) {
        // Not implemented
    }
}
