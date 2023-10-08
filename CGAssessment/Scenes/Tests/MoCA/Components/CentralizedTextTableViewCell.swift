//
//  CentralizedTextTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import UIKit

class CentralizedTextTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var labelLeadingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var labelTrailingConstraint: NSLayoutConstraint?
    @IBOutlet private weak var labelBottomConstraint: NSLayoutConstraint?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Public Methods

    func setup(text: String, leadingConstraint: CGFloat = 50, bottomConstraint: CGFloat = 20, textStyle: Style = .semibold, textSize: CGFloat = 17) {
        titleLabel?.text = text
        titleLabel?.font = .compactDisplay(withStyle: textStyle, size: textSize)
        labelLeadingConstraint?.constant = leadingConstraint
        labelTrailingConstraint?.constant = leadingConstraint
        labelBottomConstraint?.constant = bottomConstraint
    }

    // MARK: - Private Methods

    private func setupView() {
        titleLabel?.font = .compactDisplay(withStyle: .semibold, size: 17)
    }

}
