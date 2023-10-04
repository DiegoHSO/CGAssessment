//
//  GripStrengthPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import Foundation

protocol GripStrengthPresentationLogic: AnyObject {
    func route(toRoute route: GripStrengthModels.Routing)
    func presentData(viewModel: GripStrengthModels.ControllerViewModel)
}

class GripStrengthPresenter: GripStrengthPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: GripStrengthDisplayLogic?

    // MARK: - Init

    init(viewController: GripStrengthDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: GripStrengthModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: GripStrengthModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
