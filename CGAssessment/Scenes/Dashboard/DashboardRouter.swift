//
//  DashboardRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import UIKit

protocol DashboardRoutingLogic {
    func routeToNewCGA()
    func routeToPatients()
    func routeToReports()
    func routeToCGAs()
    func routeToCGA(cgaId: UUID?)
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
        guard let newCGAController = NewCGABuilder.build() else { return }

        viewController?.navigationController?.pushViewController(newCGAController, animated: true)
    }

    func routeToPatients() {
        guard let patientsController = PatientsBuilder.build() else { return }

        viewController?.navigationController?.pushViewController(patientsController, animated: true)
    }

    func routeToReports() {
        // Not implemented
    }

    func routeToCGAs() {
        viewController?.navigationController?.tabBarController?.selectedIndex = 1
    }

    func routeToCGA(cgaId: UUID?) {
        guard let cgaDomainsController = CGADomainsBuilder.build(patientId: nil, cgaId: cgaId) else {
            return
        }

        viewController?.navigationController?.pushViewController(cgaDomainsController, animated: true)
    }
}
