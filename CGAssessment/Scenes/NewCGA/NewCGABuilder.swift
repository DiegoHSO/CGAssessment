//
//  NewCGABuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import UIKit

class NewCGABuilder {

    static func build() -> UIViewController? {
        let storyboard = UIStoryboard(name: "NewCGA", bundle: Bundle.main)
        guard let newCGAController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? NewCGAViewController else {
            return nil
        }

        let presenter = NewCGAPresenter(viewController: newCGAController)
        let interactor = NewCGAInteractor(presenter: presenter, worker: NewCGAWorker())
        let router = NewCGARouter(viewController: newCGAController)

        newCGAController.setupArchitecture(interactor: interactor, router: router)

        return newCGAController
    }
}
