//
//  DashboardRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import UIKit

protocol DashboardRoutingLogic {
    func routeToNewCGA()
    func routeToPacients()
    func routeToReports()
    func routeToCGAs()
    func routeToCGADomains()
    func routeToCGA(cgaId: Int)
}

class DashboardRouter: DashboardRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToNewCGA() {
        let storyboard = UIStoryboard(name: "NewCGA", bundle: Bundle.main)
        guard let newCGAController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? NewCGAViewController else {
            return
        }

        let presenter = NewCGAPresenter(viewController: newCGAController)
        let interactor = NewCGAInteractor(presenter: presenter, worker: NewCGAWorker())
        let router = NewCGARouter(viewController: newCGAController)

        newCGAController.setupArchitecture(interactor: interactor, router: router)

        viewController?.navigationController?.pushViewController(newCGAController, animated: true)
    }

    func routeToPacients() {
        // Not implemented
    }

    func routeToReports() {
        // Not implemented
    }

    func routeToCGAs() {
        // Not implemented
    }

    func routeToCGADomains() {
        let storyboard = UIStoryboard(name: "CGADomains", bundle: Bundle.main)
        guard let cgaDomainsController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? CGADomainsViewController else {
            return
        }

        let presenter = CGADomainsPresenter(viewController: cgaDomainsController)
        let interactor = CGADomainsInteractor(presenter: presenter, patientId: -1)
        let router = CGADomainsRouter(viewController: cgaDomainsController)

        cgaDomainsController.setupArchitecture(interactor: interactor, router: router)

        viewController?.navigationController?.pushViewController(cgaDomainsController, animated: true)
    }

    func routeToCGA(cgaId: Int) {
        // Not implemented
    }
}
