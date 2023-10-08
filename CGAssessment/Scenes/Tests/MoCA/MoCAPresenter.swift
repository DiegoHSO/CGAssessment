//
//  MoCAPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import Foundation

protocol MoCAPresentationLogic: AnyObject {
    func route(toRoute route: MoCAModels.Routing)
    func presentData(viewModel: MoCAModels.ControllerViewModel)
}

class MoCAPresenter: MoCAPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: MoCADisplayLogic?

    // MARK: - Init

    init(viewController: MoCADisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: MoCAModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: MoCAModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
