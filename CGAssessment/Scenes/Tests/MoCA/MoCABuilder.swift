//
//  MoCABuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import UIKit

class MoCABuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "MoCA", bundle: Bundle.main)
        guard let mocaController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? MoCAViewController else {
            return nil
        }

        let presenter = MoCAPresenter(viewController: mocaController)
        let interactor = MoCAInteractor(presenter: presenter, worker: MoCAWorker(cgaId: cgaId), cgaId: cgaId)
        let router = MoCARouter(viewController: mocaController)

        mocaController.setupArchitecture(interactor: interactor, router: router)

        return mocaController
    }

}
