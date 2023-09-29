//
//  ResultsBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import UIKit

class ResultsBuilder {

    static func build(test: SingleDomainModels.Test, results: Any) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Results", bundle: Bundle.main)
        guard let resultsController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? ResultsViewController else {
            return nil
        }

        let presenter = ResultsPresenter(viewController: resultsController)
        let interactor = ResultsInteractor(presenter: presenter, worker: .init(), test: test, results: results)
        let router = ResultsRouter(viewController: resultsController)

        resultsController.setupArchitecture(interactor: interactor, router: router)

        return resultsController
    }

}