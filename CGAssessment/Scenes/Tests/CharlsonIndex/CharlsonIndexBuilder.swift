//
//  CharlsonIndexBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import UIKit

class CharlsonIndexBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "CharlsonIndex", bundle: Bundle.main)
        guard let charlsonIndexController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? CharlsonIndexViewController else {
            return nil
        }

        let presenter = CharlsonIndexPresenter(viewController: charlsonIndexController)
        let interactor = CharlsonIndexInteractor(presenter: presenter, worker: CharlsonIndexWorker(cgaId: cgaId), cgaId: cgaId)
        let router = CharlsonIndexRouter(viewController: charlsonIndexController)

        charlsonIndexController.setupArchitecture(interactor: interactor, router: router)

        return charlsonIndexController
    }

}
