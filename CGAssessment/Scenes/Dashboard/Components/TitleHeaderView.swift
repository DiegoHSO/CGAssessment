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

    // MARK: - Public Methods

    func setup(title: String, textColor: UIColor? = UIColor(named: "Label-1"),
               backgroundColor: UIColor? = .clear) {
        titleLabel?.text = title
        titleLabel?.textColor = textColor
        contentView.backgroundColor = backgroundColor
    }

}
