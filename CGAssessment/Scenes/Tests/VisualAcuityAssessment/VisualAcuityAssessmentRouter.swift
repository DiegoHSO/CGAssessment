//
//  VisualAcuityAssessmentRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 10/10/23.
//

import UIKit

protocol VisualAcuityAssessmentRoutingLogic {
    func routeToTestResults(test: SingleDomainModels.Test, results: VisualAcuityAssessmentModels.TestResults, cgaId: UUID?)
    func routeToPrinting(fileURL: URL?)
    func routeToFileSaving(fileURL: URL?)
}

class VisualAcuityAssessmentRouter: VisualAcuityAssessmentRoutingLogic {

    // MARK: - Private Properties

    private weak var viewController: UIViewController?

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func routeToTestResults(test: SingleDomainModels.Test, results: VisualAcuityAssessmentModels.TestResults, cgaId: UUID?) {
        guard let resultsController = ResultsBuilder.build(test: test, results: results, cgaId: cgaId) else { return }

        viewController?.navigationController?.pushViewController(resultsController, animated: true)
    }

    func routeToPrinting(fileURL: URL?) {
        guard let fileURL else { return }
        if UIPrintInteractionController.canPrint(fileURL) {
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = fileURL.lastPathComponent
            printInfo.outputType = .general
            printInfo.orientation = .portrait

            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.showsNumberOfCopies = true

            printController.printingItem = fileURL

            printController.present(animated: true, completionHandler: nil)
        }
    }

    func routeToFileSaving(fileURL: URL?) {
        guard let fileURL else { return }
        let activityViewController = UIActivityViewController(activityItems: [fileURL],
                                                              applicationActivities: nil)
        viewController?.present(activityViewController, animated: true)
    }
}
