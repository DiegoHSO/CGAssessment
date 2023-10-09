//
//  VerbalFluencyPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import Foundation

protocol VerbalFluencyPresentationLogic: AnyObject {
    func route(toRoute route: VerbalFluencyModels.Routing)
    func presentData(viewModel: VerbalFluencyModels.ControllerViewModel)
}

class VerbalFluencyPresenter: VerbalFluencyPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: VerbalFluencyDisplayLogic?

    // MARK: - Init

    init(viewController: VerbalFluencyDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: VerbalFluencyModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: VerbalFluencyModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
