//
//  CharlsonIndexPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import Foundation

protocol CharlsonIndexPresentationLogic: AnyObject {
    func route(toRoute route: CharlsonIndexModels.Routing)
    func presentData(viewModel: CharlsonIndexModels.ControllerViewModel)
}

class CharlsonIndexPresenter: CharlsonIndexPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: CharlsonIndexDisplayLogic?

    // MARK: - Init

    init(viewController: CharlsonIndexDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: CharlsonIndexModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: CharlsonIndexModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
