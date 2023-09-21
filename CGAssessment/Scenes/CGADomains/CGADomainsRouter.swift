//
//  CGADomainsRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 20/09/23.
//

import UIKit

protocol CGADomainsRoutingLogic {
    func routeToDomainTests(domain: CGADomainsModels.Domain)
}

class CGADomainsRouter: CGADomainsRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToDomainTests(domain: CGADomainsModels.Domain) {
        // Not implemented
    }
}
