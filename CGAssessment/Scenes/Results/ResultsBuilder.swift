//
//  ResultsBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import UIKit

class ResultsBuilder {

    static func build(test: SingleDomainModels.Test, results: Any, cgaId: UUID?, isInSpecialFlow: Bool = false) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Results", bundle: Bundle.main)
        guard let resultsController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? ResultsViewController else {
            return nil
        }

        let presenter = ResultsPresenter(viewController: resultsController)
        let interactor = ResultsInteractor(presenter: presenter, worker: .init(dao: CoreDataDAO(), cgaId: cgaId),
                                           test: test, results: results, isInSpecialFlow: isInSpecialFlow)
        let router = ResultsRouter(viewController: resultsController, cgaId: cgaId)

        resultsController.setupArchitecture(interactor: interactor, router: router)

        return resultsController
    }

}
