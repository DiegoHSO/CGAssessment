//
//  MiniNutritionalAssessmentRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import UIKit

protocol MiniNutritionalAssessmentRoutingLogic {
    func routeToTestResults(test: SingleDomainModels.Test, results: MiniNutritionalAssessmentModels.TestResults, cgaId: UUID?)
    func openBottomSheet(viewModel: CGAModels.BottomSheetViewModel)
}

class MiniNutritionalAssessmentRouter: MiniNutritionalAssessmentRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToTestResults(test: SingleDomainModels.Test, results: MiniNutritionalAssessmentModels.TestResults, cgaId: UUID?) {
        guard let resultsController = ResultsBuilder.build(test: test, results: results, cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(resultsController, animated: true)
    }

    func openBottomSheet(viewModel: CGAModels.BottomSheetViewModel) {
        guard let bottomSheetController = BottomSheetBuilder.build(viewModel: viewModel,
                                                                   height: viewController?.view.frame.height ?? 0) else { return }

        viewController?.present(bottomSheetController, animated: true, completion: nil)
    }
}
