//
//  EmptyStateTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 03/10/23.
//

import UIKit

class EmptyStateTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var emptyStateTitle: UILabel?
    @IBOutlet private weak var actionButton: UIButton?
    @IBOutlet private weak var cellLeadingConstraint: NSLayoutConstraint?

    // MARK: - Public Methods

    func setup(title: String, buttonTitle: String, leadingConstraint: CGFloat = 30) {
        emptyStateTitle?.text = title
        actionButton?.setTitle(buttonTitle, for: .normal)
        actionButton?.titleLabel?.font = .compactDisplay(withStyle: .medium, size: 16)
        cellLeadingConstraint?.constant = leadingConstraint
    }

}
