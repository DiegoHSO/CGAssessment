//
//  MiniNutritionalAssessmentBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import UIKit

class MiniNutritionalAssessmentBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "MiniNutritionalAssessment", bundle: Bundle.main)
        guard let miniNutritionalAssessmentController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? MiniNutritionalAssessmentViewController else {
            return nil
        }

        let presenter = MiniNutritionalAssessmentPresenter(viewController: miniNutritionalAssessmentController)
        let interactor = MiniNutritionalAssessmentInteractor(presenter: presenter, worker: MiniNutritionalAssessmentWorker(cgaId: cgaId), cgaId: cgaId)
        let router = MiniNutritionalAssessmentRouter(viewController: miniNutritionalAssessmentController)

        miniNutritionalAssessmentController.setupArchitecture(interactor: interactor, router: router)

        return miniNutritionalAssessmentController
    }

}
