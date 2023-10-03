//
//  CGAsRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import UIKit

protocol CGAsRoutingLogic {
    func routeToCGA(cgaId: UUID?)
    func routeToNewCGA()
}

class CGAsRouter: CGAsRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToCGA(cgaId: UUID?) {
        guard let cgaDomainsController = CGADomainsBuilder.build(patientId: nil, cgaId: cgaId) else {
            return
        }

        viewController?.navigationController?.pushViewController(cgaDomainsController, animated: true)
    }

    func routeToNewCGA() {
        guard let newCGAController = NewCGABuilder.build() else { return }

        viewController?.navigationController?.pushViewController(newCGAController, animated: true)
    }
}
