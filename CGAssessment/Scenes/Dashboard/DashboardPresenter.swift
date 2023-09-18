//
//  DashboardPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import Foundation

protocol DashboardPresentationLogic: AnyObject {
    func route(toRoute route: DashboardModels.Routing)
    func presentData(viewModel: DashboardModels.ViewModel)
}

class DashboardPresenter: DashboardPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: DashboardDisplayLogic?

    // MARK: - Init

    init(viewController: DashboardDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: DashboardModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: DashboardModels.ViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
