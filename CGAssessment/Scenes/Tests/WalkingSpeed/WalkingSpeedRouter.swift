//
//  WalkingSpeedRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import UIKit

protocol WalkingSpeedRoutingLogic {
    func routeToTestResults(test: SingleDomainModels.Test, results: WalkingSpeedModels.TestResults)
}

class WalkingSpeedRouter: WalkingSpeedRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToTestResults(test: SingleDomainModels.Test, results: WalkingSpeedModels.TestResults) {
        let storyboard = UIStoryboard(name: "Results", bundle: Bundle.main)
        guard let resultsController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? ResultsViewController else {
            return
        }

        let presenter = ResultsPresenter(viewController: resultsController)
        let interactor = ResultsInteractor(presenter: presenter, worker: .init(), test: test, results: results)
        let router = ResultsRouter(viewController: resultsController)

        resultsController.setupArchitecture(interactor: interactor, router: router)

        viewController?.navigationController?.pushViewController(resultsController, animated: true)
    }
}
