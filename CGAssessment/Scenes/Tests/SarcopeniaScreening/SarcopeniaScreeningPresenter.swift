//
//  SarcopeniaScreeningPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import Foundation

protocol SarcopeniaScreeningPresentationLogic: AnyObject {
    func route(toRoute route: SarcopeniaScreeningModels.Routing)
    func presentData(viewModel: SarcopeniaScreeningModels.ControllerViewModel)
}

class SarcopeniaScreeningPresenter: SarcopeniaScreeningPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: SarcopeniaScreeningDisplayLogic?

    // MARK: - Init

    init(viewController: SarcopeniaScreeningDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: SarcopeniaScreeningModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: SarcopeniaScreeningModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
