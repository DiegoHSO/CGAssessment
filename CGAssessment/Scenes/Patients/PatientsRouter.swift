//
//  PatientsRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 03/10/23.
//

import UIKit

protocol PatientsRoutingLogic {
    func routeToCGAs(patientId: UUID?)
    func routeToNewCGA()
}

class PatientsRouter: PatientsRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToCGAs(patientId: UUID?) {
        guard let cgasController = CGAsBuilder.build(patientId: patientId) else {
            return
        }

        viewController?.navigationController?.pushViewController(cgasController, animated: true)
    }

    func routeToNewCGA() {
        guard let newCGAController = NewCGABuilder.build() else { return }

        viewController?.navigationController?.pushViewController(newCGAController, animated: true)
    }
}
