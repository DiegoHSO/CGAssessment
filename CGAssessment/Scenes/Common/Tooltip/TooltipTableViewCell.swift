//
//  TooltipTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 20/09/23.
//

import UIKit

class TooltipTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var tooltipSymbolLabel: UILabel?
    @IBOutlet private weak var tooltipTextLabel: UILabel?

    // MARK: - Public Methods

    func setup(text: String, symbol: String) {
        tooltipTextLabel?.text = text
        tooltipSymbolLabel?.text = symbol
    }

}
