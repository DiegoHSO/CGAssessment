//
//  CGADomainsBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 03/10/23.
//

import UIKit

class CGADomainsBuilder {

    static func build(patientId: UUID?, cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "CGADomains", bundle: Bundle.main)
        guard let cgaDomainsController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? CGADomainsViewController else {
            return nil
        }

        let presenter = CGADomainsPresenter(viewController: cgaDomainsController)
        let interactor = CGADomainsInteractor(presenter: presenter, worker: CGADomainsWorker(), patientId: patientId, cgaId: cgaId)
        let router = CGADomainsRouter(viewController: cgaDomainsController)

        cgaDomainsController.setupArchitecture(interactor: interactor, router: router)

        return cgaDomainsController
    }

}
