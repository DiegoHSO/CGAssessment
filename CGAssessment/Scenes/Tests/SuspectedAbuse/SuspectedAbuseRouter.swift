//
//  SuspectedAbuseRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import UIKit

protocol SuspectedAbuseRoutingLogic {
    func routeToChemotherapyToxicityRisk(cgaId: UUID?)
}

class SuspectedAbuseRouter: SuspectedAbuseRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToChemotherapyToxicityRisk(cgaId: UUID?) {
        guard let chemotherapyToxicityRiskController = ChemotherapyToxicityRiskBuilder.build(cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(chemotherapyToxicityRiskController, animated: true)
    }
}
