//
//  HearingLossAssessmentBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import UIKit

class HearingLossAssessmentBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "HearingLossAssessment", bundle: Bundle.main)
        guard let hearingLossAssessmentController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? HearingLossAssessmentViewController else {
            return nil
        }

        let presenter = HearingLossAssessmentPresenter(viewController: hearingLossAssessmentController)
        let interactor = HearingLossAssessmentInteractor(presenter: presenter, worker: HearingLossAssessmentWorker(cgaId: cgaId), cgaId: cgaId)
        let router = HearingLossAssessmentRouter(viewController: hearingLossAssessmentController)

        hearingLossAssessmentController.setupArchitecture(interactor: interactor, router: router)

        return hearingLossAssessmentController
    }

}
