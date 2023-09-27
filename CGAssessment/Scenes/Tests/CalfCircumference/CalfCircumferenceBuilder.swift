//
//  CalfCircumferenceBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import UIKit

class CalfCircumferenceBuilder {

    static func build() -> UIViewController? {
        let storyboard = UIStoryboard(name: "CalfCircumference", bundle: Bundle.main)
        guard let calfCircumferenceController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? CalfCircumferenceViewController else {
            return nil
        }

        let presenter = CalfCircumferencePresenter(viewController: calfCircumferenceController)
        let interactor = CalfCircumferenceInteractor(presenter: presenter)
        let router = CalfCircumferenceRouter(viewController: calfCircumferenceController)

        calfCircumferenceController.setupArchitecture(interactor: interactor, router: router)

        return calfCircumferenceController
    }

}
