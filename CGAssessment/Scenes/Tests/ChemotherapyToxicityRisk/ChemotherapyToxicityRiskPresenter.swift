//
//  ChemotherapyToxicityRiskPresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import Foundation

// swiftlint:disable:next type_name
protocol ChemotherapyToxicityRiskPresentationLogic: AnyObject {
    func route(toRoute route: ChemotherapyToxicityRiskModels.Routing)
    func presentData(viewModel: ChemotherapyToxicityRiskModels.ControllerViewModel)
}

class ChemotherapyToxicityRiskPresenter: ChemotherapyToxicityRiskPresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: ChemotherapyToxicityRiskDisplayLogic?

    // MARK: - Init

    init(viewController: ChemotherapyToxicityRiskDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: ChemotherapyToxicityRiskModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: ChemotherapyToxicityRiskModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
