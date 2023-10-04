//
//  NavigationBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/09/23.
//

import UIKit

typealias NavigationFactory = (UIViewController) -> (UINavigationController)

class NavigationBuilder {

    static func build(rootView: UIViewController) -> UINavigationController {
        let textStyleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label1 ?? .clear,
            .font: UIFont.compactDisplay(withStyle: .semibold, size: 17)
        ]

        let largeTextStyleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label1 ?? .clear,
            .font: UIFont.compactDisplay(withStyle: .bold, size: 34)
        ]

        let navigationController = UINavigationController(rootViewController: rootView)
        navigationController.navigationBar.barTintColor = .primary
        navigationController.navigationBar.tintColor = .background2
        navigationController.navigationBar.titleTextAttributes = textStyleAttributes
        navigationController.navigationBar.largeTitleTextAttributes = largeTextStyleAttributes
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .automatic

        return navigationController
    }
}
