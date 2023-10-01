//
//  TimedUpAndGoBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import UIKit

class TimedUpAndGoBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "TimedUpAndGo", bundle: Bundle.main)
        guard let timedUpAndGoController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? TimedUpAndGoViewController else {
            return nil
        }

        let presenter = TimedUpAndGoPresenter(viewController: timedUpAndGoController)
        let interactor = TimedUpAndGoInteractor(presenter: presenter, worker: TimedUpAndGoWorker(cgaId: cgaId), cgaId: cgaId)
        let router = TimedUpAndGoRouter(viewController: timedUpAndGoController)

        timedUpAndGoController.setupArchitecture(interactor: interactor, router: router)

        return timedUpAndGoController
    }

}
