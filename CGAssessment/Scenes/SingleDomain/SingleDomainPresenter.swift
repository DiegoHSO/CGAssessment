//
//  SingleDomainPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 23/09/23.
//

import Foundation

protocol SingleDomainPresentationLogic: AnyObject {
    func route(toRoute route: SingleDomainModels.Routing)
    func presentData(viewModel: SingleDomainModels.ControllerViewModel)
}

class SingleDomainPresenter: SingleDomainPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: SingleDomainDisplayLogic?

    // MARK: - Init

    init(viewController: SingleDomainDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: SingleDomainModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: SingleDomainModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
