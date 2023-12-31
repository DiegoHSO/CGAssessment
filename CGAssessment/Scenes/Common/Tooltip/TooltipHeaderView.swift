//
//  TooltipHeaderView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 20/09/23.
//

import UIKit

class TooltipHeaderView: UITableViewHeaderFooterView {

    // MARK: - Private Properties

    @IBOutlet private weak var tooltipTextLabel: UILabel?

    // MARK: - Public Methods

    func setup(text: String) {
        tooltipTextLabel?.text = text
    }

}
