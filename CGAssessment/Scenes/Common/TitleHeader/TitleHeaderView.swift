//
//  TitleHeaderView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 09/09/23.
//

import UIKit

class TitleHeaderView: UITableViewHeaderFooterView {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var labelLeadingConstraint: NSLayoutConstraint?
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!

    // MARK: - Public Methods

    func setup(title: String, textColor: UIColor? = .label1, textSize: CGFloat = 20,
               backgroundColor: UIColor? = .clear, leadingConstraint: CGFloat = 30,
               bottomConstraint: CGFloat = 20) {
        titleLabel?.text = title
        titleLabel?.textColor = textColor
        titleLabel?.font = .compactDisplay(withStyle: .semibold, size: textSize)
        labelLeadingConstraint?.constant = leadingConstraint
        labelBottomConstraint.constant = bottomConstraint
        contentView.backgroundColor = backgroundColor
    }

    func setDisabledState() {
        titleLabel?.alpha = 0.4
    }

    func setEnabledState() {
        titleLabel?.alpha = 1
    }

}
