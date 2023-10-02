//
//  CGAsRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import UIKit

protocol CGAsRoutingLogic {
    func routeToCGA(cgaId: UUID?)
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
        let storyboard = UIStoryboard(name: "CGADomains", bundle: Bundle.main)
        guard let cgaDomainsController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? CGADomainsViewController else {
            return
        }

        let presenter = CGADomainsPresenter(viewController: cgaDomainsController)
        let interactor = CGADomainsInteractor(presenter: presenter, worker: CGADomainsWorker(), patientId: nil, cgaId: cgaId)
        let router = CGADomainsRouter(viewController: cgaDomainsController)

        cgaDomainsController.setupArchitecture(interactor: interactor, router: router)

        viewController?.navigationController?.pushViewController(cgaDomainsController, animated: true)
    }
}
