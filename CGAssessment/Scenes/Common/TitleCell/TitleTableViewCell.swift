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
    @IBOutlet private weak var labelTrailingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var labelBottomConstraint: NSLayoutConstraint?

    // MARK: - Public Methods

    func setup(title: String, textColor: UIColor? = .label1, backgroundColor: UIColor? = .clear,
               leadingConstraint: CGFloat = 30, bottomConstraint: CGFloat = 20, fontStyle: Style = .semibold, fontSize: CGFloat = 18) {
        titleLabel?.text = title
        titleLabel?.textColor = textColor
        titleLabel?.font = .compactDisplay(withStyle: fontStyle, size: fontSize)
        labelLeadingConstraint?.constant = leadingConstraint
        labelTrailingConstraint?.constant = leadingConstraint
        labelBottomConstraint?.constant = bottomConstraint
        contentView.backgroundColor = backgroundColor
    }

}
