//
//  SuspectedAbuseBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import UIKit

class SuspectedAbuseBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "SuspectedAbuse", bundle: Bundle.main)
        guard let suspectedAbuseController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? SuspectedAbuseViewController else {
            return nil
        }

        let presenter = SuspectedAbusePresenter(viewController: suspectedAbuseController)
        let interactor = SuspectedAbuseInteractor(presenter: presenter, worker: SuspectedAbuseWorker(cgaId: cgaId), cgaId: cgaId)
        let router = SuspectedAbuseRouter(viewController: suspectedAbuseController)

        suspectedAbuseController.setupArchitecture(interactor: interactor, router: router)

        return suspectedAbuseController
    }

}
