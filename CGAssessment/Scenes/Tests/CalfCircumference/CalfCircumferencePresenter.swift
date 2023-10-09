//
//  CalfCircumferencePresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import Foundation

protocol CalfCircumferencePresentationLogic: AnyObject {
    func route(toRoute route: CalfCircumferenceModels.Routing)
    func presentData(viewModel: CalfCircumferenceModels.ControllerViewModel)
}

class CalfCircumferencePresenter: CalfCircumferencePresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: CalfCircumferenceDisplayLogic?

    // MARK: - Init

    init(viewController: CalfCircumferenceDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: CalfCircumferenceModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: CalfCircumferenceModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
