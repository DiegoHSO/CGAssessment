//
//  PolypharmacyCriteriaBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import UIKit

class PolypharmacyCriteriaBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "PolypharmacyCriteria", bundle: Bundle.main)
        guard let polypharmacyCriteriaController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? PolypharmacyCriteriaViewController else {
            return nil
        }

        let presenter = PolypharmacyCriteriaPresenter(viewController: polypharmacyCriteriaController)
        let interactor = PolypharmacyCriteriaInteractor(presenter: presenter, worker: PolypharmacyCriteriaWorker(cgaId: cgaId), cgaId: cgaId)
        let router = PolypharmacyCriteriaRouter(viewController: polypharmacyCriteriaController)

        polypharmacyCriteriaController.setupArchitecture(interactor: interactor, router: router)

        return polypharmacyCriteriaController
    }

}
