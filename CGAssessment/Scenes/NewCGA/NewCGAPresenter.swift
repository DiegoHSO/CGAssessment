//
//  NewCGAPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import Foundation

protocol NewCGAPresentationLogic: AnyObject {
    func route(toRoute route: NewCGAModels.Routing)
    func presentData(viewModel: NewCGAModels.ControllerViewModel)
}

class NewCGAPresenter: NewCGAPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: NewCGADisplayLogic?

    // MARK: - Init

    init(viewController: NewCGADisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: NewCGAModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: NewCGAModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
