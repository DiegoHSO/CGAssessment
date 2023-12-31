//
//  TabBarViewController.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/09/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    // MARK: - Init

    init(tabs: CGAModels.Tabs) {
        super.init(nibName: nil, bundle: nil)

        viewControllers = [tabs.home, tabs.cgas].compactMap { $0 }
        tabBar.tintColor = .label7
        tabBar.backgroundColor = .background11
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        tabBar.accessibilityIdentifier = "TabBarViewController-TabBar"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
