//
//  MiniMentalStateExamPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/10/23.
//

import Foundation

protocol MiniMentalStateExamPresentationLogic: AnyObject {
    func route(toRoute route: MiniMentalStateExamModels.Routing)
    func presentData(viewModel: MiniMentalStateExamModels.ControllerViewModel)
}

class MiniMentalStateExamPresenter: MiniMentalStateExamPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: MiniMentalStateExamDisplayLogic?

    // MARK: - Init

    init(viewController: MiniMentalStateExamDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: MiniMentalStateExamModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: MiniMentalStateExamModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
