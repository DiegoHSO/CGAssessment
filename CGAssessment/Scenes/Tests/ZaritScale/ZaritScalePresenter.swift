//
//  ZaritScalePresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 12/10/23.
//

import Foundation

// swiftlint:disable:next type_name
protocol ZaritScalePresentationLogic: AnyObject {
    func route(toRoute route: ZaritScaleModels.Routing)
    func presentData(viewModel: ZaritScaleModels.ControllerViewModel)
}

class ZaritScalePresenter: ZaritScalePresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: ZaritScaleDisplayLogic?

    // MARK: - Init

    init(viewController: ZaritScaleDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: ZaritScaleModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: ZaritScaleModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
