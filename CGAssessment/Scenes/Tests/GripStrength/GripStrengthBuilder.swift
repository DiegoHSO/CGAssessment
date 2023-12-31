//
//  GripStrengthBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import UIKit

class GripStrengthBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "GripStrength", bundle: Bundle.main)
        guard let gripStrengthController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? GripStrengthViewController else {
            return nil
        }

        let presenter = GripStrengthPresenter(viewController: gripStrengthController)
        let interactor = GripStrengthInteractor(presenter: presenter, worker: GripStrengthWorker(cgaId: cgaId), cgaId: cgaId)
        let router = GripStrengthRouter(viewController: gripStrengthController)

        gripStrengthController.setupArchitecture(interactor: interactor, router: router)

        return gripStrengthController
    }

}
