//
//  PatientsPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 03/10/23.
//

import Foundation

protocol PatientsPresentationLogic: AnyObject {
    func route(toRoute route: PatientsModels.Routing)
    func presentData(viewModel: PatientsModels.ControllerViewModel)
    func presentDeletionAlert(for indexPath: IndexPath)
    func presentErrorDeletingAlert()
}

class PatientsPresenter: PatientsPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: PatientsDisplayLogic?

    // MARK: - Init

    init(viewController: PatientsDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: PatientsModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: PatientsModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

    func presentDeletionAlert(for indexPath: IndexPath) {
        viewController?.presentDeletionAlert(for: indexPath)
    }

    func presentErrorDeletingAlert() {
        viewController?.presentErrorDeletingAlert()
    }

}
