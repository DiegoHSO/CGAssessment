//
//  TabBarRouter.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/09/23.
//

import UIKit

class TabBarRouter {

    // MARK: - Private Properties

    private var submodules: Submodules
    private weak var viewController: UIViewController?

    // MARK: - Public Properties

    typealias Submodules = (
        home: UIViewController?,
        cgas: UIViewController?
    )

    // MARK: - Init

    init(viewController: UIViewController?, submodules: Submodules) {
        self.viewController = viewController
        self.submodules = submodules
    }

}

// MARK: - TabBarRouter Extension

extension TabBarRouter {
    static func tabs(usingSubmodules submodules: Submodules) -> CGAModels.Tabs {
        let homeTabBarItem = UITabBarItem(title: LocalizedTable.home.localized,
                                          image: UIImage.TabBar.dashboardNormal,
                                          selectedImage: UIImage.TabBar.dashboardSelected)

        let cgasTabBarItem = UITabBarItem(title: LocalizedTable.cgas.localized,
                                          image: UIImage.TabBar.cgasNormal,
                                          selectedImage: UIImage.TabBar.cgasSelected)

        submodules.home?.tabBarItem = homeTabBarItem
        submodules.cgas?.tabBarItem = cgasTabBarItem

        return (
            home: submodules.home,
            cgas: submodules.cgas
        )
    }
}
