//
//  BottomSheetBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 12/10/23.
//

import UIKit

class BottomSheetBuilder {

    static func build(viewModel: CGAModels.BottomSheetViewModel, height: CGFloat) -> UIViewController? {
        let storyboard = UIStoryboard(name: "BottomSheet", bundle: Bundle.main)
        guard let bottomSheetController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? BottomSheetViewController else {
            return nil
        }

        bottomSheetController.setupArchitecture(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: bottomSheetController)

        let multiplier = 0.3
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

        return navigationController
    }

}
