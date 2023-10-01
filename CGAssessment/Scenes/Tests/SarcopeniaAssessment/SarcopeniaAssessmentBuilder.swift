//
//  SarcopeniaAssessmentBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 28/09/23.
//

import UIKit

class SarcopeniaAssessmentBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "SarcopeniaAssessment", bundle: Bundle.main)
        guard let sarcopeniaAssessmentController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? SarcopeniaAssessmentViewController else {
            return nil
        }

        let presenter = SarcopeniaAssessmentPresenter(viewController: sarcopeniaAssessmentController)
        let interactor = SarcopeniaAssessmentInteractor(presenter: presenter, worker: SarcopeniaAssessmentWorker(cgaId: cgaId), cgaId: cgaId)
        let router = SarcopeniaAssessmentRouter(viewController: sarcopeniaAssessmentController)

        sarcopeniaAssessmentController.setupArchitecture(interactor: interactor, router: router)

        return sarcopeniaAssessmentController
    }

}
