//
//  KatzScaleBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import UIKit

class KatzScaleBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "KatzScale", bundle: Bundle.main)
        guard let katzScaleController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? KatzScaleViewController else {
            return nil
        }

        let presenter = KatzScalePresenter(viewController: katzScaleController)
        let interactor = KatzScaleInteractor(presenter: presenter, worker: KatzScaleWorker(cgaId: cgaId), cgaId: cgaId)
        let router = KatzScaleRouter(viewController: katzScaleController)

        katzScaleController.setupArchitecture(interactor: interactor, router: router)

        return katzScaleController
    }

}
