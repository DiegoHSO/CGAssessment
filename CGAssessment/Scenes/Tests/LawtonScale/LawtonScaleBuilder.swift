//
//  LawtonScaleBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import UIKit

class LawtonScaleBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "LawtonScale", bundle: Bundle.main)
        guard let lawtonScaleController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? LawtonScaleViewController else {
            return nil
        }

        let presenter = LawtonScalePresenter(viewController: lawtonScaleController)
        let interactor = LawtonScaleInteractor(presenter: presenter, worker: LawtonScaleWorker(cgaId: cgaId), cgaId: cgaId)
        let router = LawtonScaleRouter(viewController: lawtonScaleController)

        lawtonScaleController.setupArchitecture(interactor: interactor, router: router)

        return lawtonScaleController
    }

}
