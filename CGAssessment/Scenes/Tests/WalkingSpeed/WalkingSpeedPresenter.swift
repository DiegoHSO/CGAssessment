//
//  WalkingSpeedPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation

protocol WalkingSpeedPresentationLogic: AnyObject {
    func route(toRoute route: WalkingSpeedModels.Routing)
    func presentData(viewModel: WalkingSpeedModels.ControllerViewModel)
}

class WalkingSpeedPresenter: WalkingSpeedPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: WalkingSpeedDisplayLogic?

    // MARK: - Init

    init(viewController: WalkingSpeedDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: WalkingSpeedModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: WalkingSpeedModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
