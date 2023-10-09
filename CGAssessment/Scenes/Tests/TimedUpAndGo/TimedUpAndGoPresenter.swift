//
//  TimedUpAndGoPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation

protocol TimedUpAndGoPresentationLogic: AnyObject {
    func route(toRoute route: TimedUpAndGoModels.Routing)
    func presentData(viewModel: TimedUpAndGoModels.ControllerViewModel)
}

class TimedUpAndGoPresenter: TimedUpAndGoPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: TimedUpAndGoDisplayLogic?

    // MARK: - Init

    init(viewController: TimedUpAndGoDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: TimedUpAndGoModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: TimedUpAndGoModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
