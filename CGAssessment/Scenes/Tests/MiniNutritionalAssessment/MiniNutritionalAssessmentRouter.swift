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
        let storyboard = UIStoryboard(name: "BottomSheet", bundle: Bundle.main)
        guard let bottomSheetController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? BottomSheetViewController else {
            return
        }

        bottomSheetController.setupArchitecture(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: bottomSheetController)

        let multiplier = 0.3
        let height = viewController?.view.frame.height ?? 0
        let detents: [UISheetPresentationController.Detent]

        if #available(iOS 16.0, *) {
            let small = UISheetPresentationController.Detent.custom { _ in
                height * multiplier
            }

            detents = [small]
        } else {
            detents = [.medium()]
        }

        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = detents
            sheet.prefersGrabberVisible = true
        }

        viewController?.present(navigationController, animated: true, completion: nil)
    }
}
