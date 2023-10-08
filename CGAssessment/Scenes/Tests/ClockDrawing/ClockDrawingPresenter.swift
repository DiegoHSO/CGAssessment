//
//  ClockDrawingPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import Foundation

protocol ClockDrawingPresentationLogic: AnyObject {
    func route(toRoute route: ClockDrawingModels.Routing)
    func presentData(viewModel: ClockDrawingModels.ControllerViewModel)
}

class ClockDrawingPresenter: ClockDrawingPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: ClockDrawingDisplayLogic?

    // MARK: - Init

    init(viewController: ClockDrawingDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: ClockDrawingModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: ClockDrawingModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
