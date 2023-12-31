//
//  CGAsPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import Foundation

protocol CGAsPresentationLogic: AnyObject {
    func route(toRoute route: CGAsModels.Routing)
    func presentData(viewModel: CGAsModels.ControllerViewModel)
    func presentDeletionAlert(for indexPath: IndexPath)
    func presentErrorDeletingAlert()
}

class CGAsPresenter: CGAsPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: CGAsDisplayLogic?

    // MARK: - Init

    init(viewController: CGAsDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: CGAsModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: CGAsModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

    func presentDeletionAlert(for indexPath: IndexPath) {
        viewController?.presentDeletionAlert(for: indexPath)
    }

    func presentErrorDeletingAlert() {
        viewController?.presentErrorDeletingAlert()
    }
}
