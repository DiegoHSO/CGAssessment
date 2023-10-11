//
//  TooltipTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 20/09/23.
//

import UIKit

class TooltipTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var tooltipTextLabel: UILabel?
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint?

    // MARK: - Public Methods

    func setup(text: String, symbol: String, bottomConstraint: CGFloat = 20) {
        tooltipTextLabel?.text = "\(symbol)  \(text)"
        self.bottomConstraint?.constant = bottomConstraint
    }

}
