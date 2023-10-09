//
//  GeriatricDepressionScalePresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 09/10/23.
//

import Foundation

// swiftlint:disable:next type_name
protocol GeriatricDepressionScalePresentationLogic: AnyObject {
    func route(toRoute route: GeriatricDepressionScaleModels.Routing)
    func presentData(viewModel: GeriatricDepressionScaleModels.ControllerViewModel)
}

class GeriatricDepressionScalePresenter: GeriatricDepressionScalePresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: GeriatricDepressionScaleDisplayLogic?

    // MARK: - Init

    init(viewController: GeriatricDepressionScaleDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: GeriatricDepressionScaleModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: GeriatricDepressionScaleModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
