//
//  TitleTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var labelLeadingConstraint: NSLayoutConstraint?

    // MARK: - Public Methods

    func setup(title: String, textColor: UIColor? = .label1, backgroundColor: UIColor? = .clear, leadingConstraint: CGFloat = 30) {
        titleLabel?.text = title
        titleLabel?.textColor = textColor
        labelLeadingConstraint?.constant = leadingConstraint
        contentView.backgroundColor = backgroundColor
    }

}
