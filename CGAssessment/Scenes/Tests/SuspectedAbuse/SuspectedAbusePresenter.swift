//
//  SuspectedAbusePresenter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import Foundation

protocol SuspectedAbusePresentationLogic: AnyObject {
    func route(toRoute route: SuspectedAbuseModels.Routing)
    func presentData(viewModel: SuspectedAbuseModels.ControllerViewModel)
}

class SuspectedAbusePresenter: SuspectedAbusePresentationLogic {

    // MARK: - Private Properties

    private weak var viewController: SuspectedAbuseDisplayLogic?

    // MARK: - Init

    init(viewController: SuspectedAbuseDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func route(toRoute route: SuspectedAbuseModels.Routing) {
        viewController?.route(toRoute: route)
    }

    func presentData(viewModel: SuspectedAbuseModels.ControllerViewModel) {
        viewController?.presentData(viewModel: viewModel)
    }

}
