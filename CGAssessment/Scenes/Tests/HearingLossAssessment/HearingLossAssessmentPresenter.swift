//
//  HearingLossAssessmentPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

protocol HearingLossAssessmentPresentationLogic: AnyObject {
    func route(toRoute route: HearingLossAssessmentModels.Routing)
    func presentData(viewModel: HearingLossAssessmentModels.ControllerViewModel)
}

class HearingLossAssessmentPresenter: HearingLossAssessmentPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: HearingLossAssessmentDisplayLogic?

    // MARK: - Init

    init(viewController: HearingLossAssessmentDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: HearingLossAssessmentModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: HearingLossAssessmentModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
