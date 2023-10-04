//
//  PatientsBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 03/10/23.
//

import UIKit

class PatientsBuilder {

    static func build() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Patients", bundle: Bundle.main)
        guard let viewController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? PatientsViewController else {
            return nil
        }

        let presenter = PatientsPresenter(viewController: viewController)
        let interactor = PatientsInteractor(presenter: presenter, worker: PatientsWorker())
        let router = PatientsRouter(viewController: viewController)

        viewController.setupArchitecture(interactor: interactor, router: router)

        return viewController
    }

}
