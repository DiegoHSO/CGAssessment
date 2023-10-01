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
        let storyboard = UIStoryboard(name: "CGADomains", bundle: Bundle.main)
        guard let cgaDomainsController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? CGADomainsViewController else {
            return
        }

        let presenter = CGADomainsPresenter(viewController: cgaDomainsController)
        let interactor = CGADomainsInteractor(presenter: presenter, worker: CGADomainsWorker(), patientId: patientId)
        let router = CGADomainsRouter(viewController: cgaDomainsController)

        cgaDomainsController.setupArchitecture(interactor: interactor, router: router)

        viewController?.navigationController?.pushViewController(cgaDomainsController, animated: true)

        if let viewController = viewController, let index = viewController.navigationController?.viewControllers.firstIndex(of: viewController) {
            viewController.navigationController?.viewControllers.remove(at: index)
        }
    }
}
