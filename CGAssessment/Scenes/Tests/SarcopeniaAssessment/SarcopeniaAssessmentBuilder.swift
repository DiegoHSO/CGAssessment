//
//  SarcopeniaAssessmentBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import UIKit

class SarcopeniaAssessmentBuilder {

    static func build() -> UIViewController? {
        let storyboard = UIStoryboard(name: "SarcopeniaAssessment", bundle: Bundle.main)
        guard let sarcopeniaAssessmentController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? SarcopeniaAssessmentViewController else {
            return nil
        }

        let presenter = SarcopeniaAssessmentPresenter(viewController: sarcopeniaAssessmentController)
        let interactor = SarcopeniaAssessmentInteractor(presenter: presenter)
        let router = SarcopeniaAssessmentRouter(viewController: sarcopeniaAssessmentController)

        sarcopeniaAssessmentController.setupArchitecture(interactor: interactor, router: router)

        return sarcopeniaAssessmentController
    }

}
