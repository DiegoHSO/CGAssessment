//
//  MiniNutritionalAssessmentPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

protocol MiniNutritionalAssessmentPresentationLogic: AnyObject {
    func route(toRoute route: MiniNutritionalAssessmentModels.Routing)
    func presentData(viewModel: MiniNutritionalAssessmentModels.ControllerViewModel)
}

class MiniNutritionalAssessmentPresenter: MiniNutritionalAssessmentPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: MiniNutritionalAssessmentDisplayLogic?

    // MARK: - Init

    init(viewController: MiniNutritionalAssessmentDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: MiniNutritionalAssessmentModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: MiniNutritionalAssessmentModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
