//
//  NewCGABuilder.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import UIKit

class NewCGABuilder {

    static func build(usingNavigationFactory factory: NavigationFactory) -> UIViewController? {
        let storyboard = UIStoryboard(name: "NewCGA", bundle: Bundle.main)
        guard let viewController = UIStoryboard
                .instantiateInitialViewController(storyboard)() as? NewCGAViewController else {
            return nil
        }
        return factory(viewController)
    }
}
