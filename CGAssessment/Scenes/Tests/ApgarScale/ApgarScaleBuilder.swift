//
//  ApgarScaleBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 12/10/23.
//

import UIKit

class ApgarScaleBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "ApgarScale", bundle: Bundle.main)
        guard let apgarScaleController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? ApgarScaleViewController else {
            return nil
        }

        let presenter = ApgarScalePresenter(viewController: apgarScaleController)
        let interactor = ApgarScaleInteractor(presenter: presenter, worker: ApgarScaleWorker(cgaId: cgaId), cgaId: cgaId)
        let router = ApgarScaleRouter(viewController: apgarScaleController)

        apgarScaleController.setupArchitecture(interactor: interactor, router: router)

        return apgarScaleController
    }

}
