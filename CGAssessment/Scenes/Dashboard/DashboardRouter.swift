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
    func routeToCGAParameters()
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
        let interactor = NewCGAInteractor(presenter: presenter)
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

    func routeToCGAParameters() {
        // Not implemented
    }

    func routeToCGA(cgaId: Int) {
        // Not implemented
    }
}
