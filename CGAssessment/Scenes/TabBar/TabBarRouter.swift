//
//  TabBarRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/09/23.
//

import UIKit

class TabBarRouter {

    weak var viewController: UIViewController?
    private var submodules: Submodules

    /*
     typealias Submodules = (
     home: UIViewController?,
     cgas: UIViewController?,
     preferences: UIViewController?
     )
     */

    typealias Submodules = (
        home: UIViewController?,
        cgas: UIViewController?
    )

    init(viewController: UIViewController?, submodules: Submodules) {
        self.viewController = viewController
        self.submodules = submodules
    }

}

extension TabBarRouter {

    static func tabs(usingSubmodules submodules: Submodules) -> CGAModels.Tabs {
        let homeTabBarItem = UITabBarItem(title: LocalizedTable.home.localized,
                                          image: UIImage.TabBar.dashboardNormal,
                                          selectedImage: UIImage.TabBar.dashboardSelected)

        let cgasTabBarItem = UITabBarItem(title: LocalizedTable.cgas.localized,
                                          image: UIImage.TabBar.cgasNormal,
                                          selectedImage: UIImage.TabBar.cgasSelected)

        /*
         let preferencesTabBarItem = UITabBarItem(title: LocalizedTable.preferences.localized,
         image: UIImage.TabBar.preferencesNormal,
         selectedImage: UIImage.TabBar.preferencesSelected)
         submodules.preferences?.tabBarItem = preferencesTabBarItem
         */

        submodules.home?.tabBarItem = homeTabBarItem
        submodules.cgas?.tabBarItem = cgasTabBarItem

        return (
            home: submodules.home,
            cgas: submodules.cgas
        )

        /*
         return (
         home: submodules.home,
         cgas: submodules.cgas,
         preferences: submodules.preferences
         )
         */
    }

}
