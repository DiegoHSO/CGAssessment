//
//  DashboardBuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/09/23.
//

import UIKit

class DashboardBuilder {

    static func build(usingNavigationFactory factory: NavigationFactory) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: Bundle.main)
        guard let viewController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? DashboardViewController else {
            return nil
        }
        return factory(viewController)
    }
}
