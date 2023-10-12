//
//  VisualAcuityAssessmentPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 10/10/23.
//

import Foundation

protocol VisualAcuityAssessmentPresentationLogic: AnyObject {
    func route(toRoute route: VisualAcuityAssessmentModels.Routing)
    func presentData(viewModel: VisualAcuityAssessmentModels.ControllerViewModel)
}

class VisualAcuityAssessmentPresenter: VisualAcuityAssessmentPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: VisualAcuityAssessmentDisplayLogic?

    // MARK: - Init

    init(viewController: VisualAcuityAssessmentDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: VisualAcuityAssessmentModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: VisualAcuityAssessmentModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
