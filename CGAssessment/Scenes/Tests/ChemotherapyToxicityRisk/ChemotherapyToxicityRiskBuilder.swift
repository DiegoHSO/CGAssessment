//
//  ChemotherapyToxicityRiskBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 12/10/23.
//

import UIKit

class ChemotherapyToxicityRiskBuilder {

    static func build(cgaId: UUID?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "ChemotherapyToxicityRisk", bundle: Bundle.main)
        guard let chemotherapyToxicityRiskController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? ChemotherapyToxicityRiskViewController else {
            return nil
        }

        let presenter = ChemotherapyToxicityRiskPresenter(viewController: chemotherapyToxicityRiskController)
        let interactor = ChemotherapyToxicityRiskInteractor(presenter: presenter, worker: ChemotherapyToxicityRiskWorker(cgaId: cgaId), cgaId: cgaId)
        let router = ChemotherapyToxicityRiskRouter(viewController: chemotherapyToxicityRiskController)

        chemotherapyToxicityRiskController.setupArchitecture(interactor: interactor, router: router)

        return chemotherapyToxicityRiskController
    }

}
