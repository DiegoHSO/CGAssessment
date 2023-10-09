//
//  CGAsBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 02/10/23.
//

import UIKit

class CGAsBuilder {

    static func build(usingNavigationFactory factory: NavigationFactory) -> UIViewController? {
        let storyboard = UIStoryboard(name: "CGAs", bundle: Bundle.main)
        guard let viewController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? CGAsViewController else {
            return nil
        }

        let presenter = CGAsPresenter(viewController: viewController)
        let interactor = CGAsInteractor(presenter: presenter, worker: CGAsWorker(), patientId: nil)
        let router = CGAsRouter(viewController: viewController)

        viewController.setupArchitecture(interactor: interactor, router: router)

        return factory(viewController)
    }

    static func build(patientId: UUID? = nil) -> UIViewController? {
        let storyboard = UIStoryboard(name: "CGAs", bundle: Bundle.main)
        guard let viewController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? CGAsViewController else {
            return nil
        }

        let presenter = CGAsPresenter(viewController: viewController)
        let interactor = CGAsInteractor(presenter: presenter, worker: CGAsWorker(), patientId: patientId)
        let router = CGAsRouter(viewController: viewController)

        viewController.setupArchitecture(interactor: interactor, router: router)

        return viewController
    }

}
