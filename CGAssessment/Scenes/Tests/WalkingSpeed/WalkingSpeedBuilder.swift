//
//  WalkingSpeedBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import UIKit

class WalkingSpeedBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "WalkingSpeed", bundle: Bundle.main)
        guard let walkingSpeedController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? WalkingSpeedViewController else {
            return nil
        }

        let presenter = WalkingSpeedPresenter(viewController: walkingSpeedController)
        let interactor = WalkingSpeedInteractor(presenter: presenter, worker: WalkingSpeedWorker(cgaId: cgaId), cgaId: cgaId)
        let router = WalkingSpeedRouter(viewController: walkingSpeedController)

        walkingSpeedController.setupArchitecture(interactor: interactor, router: router)

        return walkingSpeedController
    }

}
