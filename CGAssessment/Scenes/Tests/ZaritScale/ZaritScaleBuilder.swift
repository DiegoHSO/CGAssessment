//
//  ZaritScaleBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 12/10/23.
//

import UIKit

class ZaritScaleBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "ZaritScale", bundle: Bundle.main)
        guard let zaritScaleController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? ZaritScaleViewController else {
            return nil
        }

        let presenter = ZaritScalePresenter(viewController: zaritScaleController)
        let interactor = ZaritScaleInteractor(presenter: presenter, worker: ZaritScaleWorker(cgaId: cgaId), cgaId: cgaId)
        let router = ZaritScaleRouter(viewController: zaritScaleController)

        zaritScaleController.setupArchitecture(interactor: interactor, router: router)

        return zaritScaleController
    }

}
