//
//  KatzScalePresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

protocol KatzScalePresentationLogic: AnyObject {
    func route(toRoute route: KatzScaleModels.Routing)
    func presentData(viewModel: KatzScaleModels.ControllerViewModel)
}

class KatzScalePresenter: KatzScalePresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: KatzScaleDisplayLogic?

    // MARK: - Init

    init(viewController: KatzScaleDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: KatzScaleModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: KatzScaleModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
