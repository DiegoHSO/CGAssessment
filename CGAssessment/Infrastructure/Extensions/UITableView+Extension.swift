//
//  UITableView+Extension.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 09/09/23.
//

import UIKit

extension UITableView {
    /// Registers the given UITableViewCell type to the tableView
    /// - Parameter cellType: The cell type to be registered
    func register(cellType: UITableViewCell.Type) {
        let nib = UINib(nibName: cellType.className, bundle: Bundle.main)
        register(nib, forCellReuseIdentifier: cellType.className)
    }

    /// Registers the given UITableViewHeader type to the tableView
    /// - Parameter headerType: The headerView to be registered
    func register(headerType: UIView.Type) {
        let nib = UINib(nibName: headerType.className, bundle: Bundle.main)
        register(nib, forHeaderFooterViewReuseIdentifier: headerType.className)
    }
}
