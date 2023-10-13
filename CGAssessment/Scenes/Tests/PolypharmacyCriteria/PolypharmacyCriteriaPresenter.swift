//
//  PolypharmacyCriteriaPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

protocol PolypharmacyCriteriaPresentationLogic: AnyObject {
    func route(toRoute route: PolypharmacyCriteriaModels.Routing)
    func presentData(viewModel: PolypharmacyCriteriaModels.ControllerViewModel)
}

class PolypharmacyCriteriaPresenter: PolypharmacyCriteriaPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: PolypharmacyCriteriaDisplayLogic?

    // MARK: - Init

    init(viewController: PolypharmacyCriteriaDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: PolypharmacyCriteriaModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: PolypharmacyCriteriaModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
