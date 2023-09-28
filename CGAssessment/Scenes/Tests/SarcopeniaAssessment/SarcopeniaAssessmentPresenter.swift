//
//  SarcopeniaAssessmentPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import Foundation

protocol SarcopeniaAssessmentPresentationLogic: AnyObject {
    func route(toRoute route: SarcopeniaAssessmentModels.Routing)
    func presentData(viewModel: SarcopeniaAssessmentModels.ControllerViewModel)
}

class SarcopeniaAssessmentPresenter: SarcopeniaAssessmentPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: SarcopeniaAssessmentDisplayLogic?

    // MARK: - Init

    init(viewController: SarcopeniaAssessmentDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: SarcopeniaAssessmentModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: SarcopeniaAssessmentModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
