//
//  LawtonScalePresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

protocol LawtonScalePresentationLogic: AnyObject {
    func route(toRoute route: LawtonScaleModels.Routing)
    func presentData(viewModel: LawtonScaleModels.ControllerViewModel)
}

class LawtonScalePresenter: LawtonScalePresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: LawtonScaleDisplayLogic?

    // MARK: - Init

    init(viewController: LawtonScaleDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: LawtonScaleModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: LawtonScaleModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
