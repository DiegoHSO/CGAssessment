//
//  CGADomainsPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 20/09/23.
//

import Foundation

protocol CGADomainsPresentationLogic: AnyObject {
    func route(toRoute route: CGADomainsModels.Routing)
    func presentData(viewModel: CGADomainsModels.ControllerViewModel)
}

class CGADomainsPresenter: CGADomainsPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: CGADomainsDisplayLogic?

    // MARK: - Init

    init(viewController: CGADomainsDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: CGADomainsModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: CGADomainsModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
