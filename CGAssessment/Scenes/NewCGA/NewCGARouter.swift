//
//  NewCGARouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import UIKit

protocol NewCGARoutingLogic {
    func routeToCGADomains(patientId: UUID)
}

class NewCGARouter: NewCGARoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToCGADomains(patientId: UUID) {
        guard let cgaDomainsController = CGADomainsBuilder.build(patientId: patientId, cgaId: nil) else {
            return
        }

        viewController?.navigationController?.pushViewController(cgaDomainsController, animated: true)

        if let viewController = viewController, let index = viewController.navigationController?.viewControllers.firstIndex(of: viewController) {
            viewController.navigationController?.viewControllers.remove(at: index)
        }
    }
}
