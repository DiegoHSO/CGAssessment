//
//  ClockDrawingBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import UIKit

class ClockDrawingBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "ClockDrawing", bundle: Bundle.main)
        guard let clockDrawingController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? ClockDrawingViewController else {
            return nil
        }

        let presenter = ClockDrawingPresenter(viewController: clockDrawingController)
        let interactor = ClockDrawingInteractor(presenter: presenter, worker: ClockDrawingWorker(cgaId: cgaId), cgaId: cgaId)
        let router = ClockDrawingRouter(viewController: clockDrawingController)

        clockDrawingController.setupArchitecture(interactor: interactor, router: router)

        return clockDrawingController
    }

}
