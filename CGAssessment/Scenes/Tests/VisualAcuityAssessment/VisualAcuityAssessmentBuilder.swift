//
//  VisualAcuityAssessmentBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 10/10/23.
//

import UIKit

class VisualAcuityAssessmentBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "VisualAcuityAssessment", bundle: Bundle.main)
        guard let visualAcuityAssessmentController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? VisualAcuityAssessmentViewController else {
            return nil
        }

        let presenter = VisualAcuityAssessmentPresenter(viewController: visualAcuityAssessmentController)
        let interactor = VisualAcuityAssessmentInteractor(presenter: presenter, worker: VisualAcuityAssessmentWorker(cgaId: cgaId), cgaId: cgaId)
        let router = VisualAcuityAssessmentRouter(viewController: visualAcuityAssessmentController)

        visualAcuityAssessmentController.setupArchitecture(interactor: interactor, router: router)

        return visualAcuityAssessmentController
    }

}
