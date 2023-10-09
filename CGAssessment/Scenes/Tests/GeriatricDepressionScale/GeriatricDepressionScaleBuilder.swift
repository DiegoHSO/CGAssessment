//
//  GeriatricDepressionScaleBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 09/10/23.
//

import UIKit

class GeriatricDepressionScaleBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "GeriatricDepressionScale", bundle: Bundle.main)
        guard let geriatricDepressionScaleController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? GeriatricDepressionScaleViewController else {
            return nil
        }

        let presenter = GeriatricDepressionScalePresenter(viewController: geriatricDepressionScaleController)
        let interactor = GeriatricDepressionScaleInteractor(presenter: presenter, worker: GeriatricDepressionScaleWorker(cgaId: cgaId), cgaId: cgaId)
        let router = GeriatricDepressionScaleRouter(viewController: geriatricDepressionScaleController)

        geriatricDepressionScaleController.setupArchitecture(interactor: interactor, router: router)

        return geriatricDepressionScaleController
    }

}
