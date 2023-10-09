//
//  ResultsPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation

protocol ResultsPresentationLogic: AnyObject {
    func route(toRoute route: ResultsModels.Routing)
    func presentData(viewModel: ResultsModels.ViewModel)
}

class ResultsPresenter: ResultsPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: ResultsDisplayLogic?

    // MARK: - Init

    init(viewController: ResultsDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: ResultsModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: ResultsModels.ViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
