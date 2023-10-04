//
//  CGADomainsRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 20/09/23.
//

import UIKit

protocol CGADomainsRoutingLogic {
    func routeToDomainTests(domain: CGADomainsModels.Domain, cgaId: UUID?)
}

class CGADomainsRouter: CGADomainsRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToDomainTests(domain: CGADomainsModels.Domain, cgaId: UUID?) {
        let storyboard = UIStoryboard(name: "SingleDomain", bundle: Bundle.main)
        guard let singleDomainController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? SingleDomainViewController else {
            return
        }

        let presenter = SingleDomainPresenter(viewController: singleDomainController)
        let interactor = SingleDomainInteractor(presenter: presenter, domain: domain,
                                                worker: SingleDomainWorker(), cgaId: cgaId)
        let router = SingleDomainRouter(viewController: singleDomainController)

        singleDomainController.setupArchitecture(interactor: interactor, router: router)

        viewController?.navigationController?.pushViewController(singleDomainController, animated: true)
    }
}
