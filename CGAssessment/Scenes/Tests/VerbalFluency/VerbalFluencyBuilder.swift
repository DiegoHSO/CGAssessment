//
//  VerbalFluencyBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import UIKit

class VerbalFluencyBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "VerbalFluency", bundle: Bundle.main)
        guard let verbalFluencyController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? VerbalFluencyViewController else {
            return nil
        }

        let presenter = VerbalFluencyPresenter(viewController: verbalFluencyController)
        let interactor = VerbalFluencyInteractor(presenter: presenter, worker: VerbalFluencyWorker(cgaId: cgaId), cgaId: cgaId)
        let router = VerbalFluencyRouter(viewController: verbalFluencyController)

        verbalFluencyController.setupArchitecture(interactor: interactor, router: router)

        return verbalFluencyController
    }

}
