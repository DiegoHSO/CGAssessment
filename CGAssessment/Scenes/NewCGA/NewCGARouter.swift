//
//  NewCGARouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import UIKit

protocol NewCGARoutingLogic {
    func routeToCGAParameters()
}

class NewCGARouter: NewCGARoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToCGAParameters() {
        // Not implemented
    }
}
