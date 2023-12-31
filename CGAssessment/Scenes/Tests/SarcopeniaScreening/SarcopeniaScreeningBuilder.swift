//
//  SarcopeniaScreeningBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import UIKit

class SarcopeniaScreeningBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "SarcopeniaScreening", bundle: Bundle.main)
        guard let sarcopeniaScreeningController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? SarcopeniaScreeningViewController else {
            return nil
        }

        let presenter = SarcopeniaScreeningPresenter(viewController: sarcopeniaScreeningController)
        let interactor = SarcopeniaScreeningInteractor(presenter: presenter, worker: SarcopeniaScreeningWorker(cgaId: cgaId), cgaId: cgaId)
        let router = SarcopeniaScreeningRouter(viewController: sarcopeniaScreeningController)

        sarcopeniaScreeningController.setupArchitecture(interactor: interactor, router: router)

        return sarcopeniaScreeningController
    }

}
