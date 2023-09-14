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
            .font: UIFont(name: "SFCompactDisplay-Bold", size: 22) ?? .systemFont(ofSize: 22)
        ]

        let largeTextStyleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label1 ?? .clear,
            .font: UIFont(name: "SFCompactDisplay-Bold", size: 34) ?? .systemFont(ofSize: 34)
        ]

        let navigationController = UINavigationController(rootViewController: rootView)
        navigationController.navigationBar.barTintColor = .primary
        navigationController.navigationBar.tintColor = .systemGreen
        navigationController.navigationBar.titleTextAttributes = textStyleAttributes
        navigationController.navigationBar.largeTitleTextAttributes = largeTextStyleAttributes
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.prefersLargeTitles = true

        return navigationController
    }
}
