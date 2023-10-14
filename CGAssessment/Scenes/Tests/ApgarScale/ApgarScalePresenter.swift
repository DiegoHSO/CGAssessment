//
//  ApgarScalePresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 12/10/23.
//

import Foundation

// swiftlint:disable:next type_name
protocol ApgarScalePresentationLogic: AnyObject {
    func route(toRoute route: ApgarScaleModels.Routing)
    func presentData(viewModel: ApgarScaleModels.ControllerViewModel)
}

class ApgarScalePresenter: ApgarScalePresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: ApgarScaleDisplayLogic?

    // MARK: - Init

    init(viewController: ApgarScaleDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: ApgarScaleModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: ApgarScaleModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
