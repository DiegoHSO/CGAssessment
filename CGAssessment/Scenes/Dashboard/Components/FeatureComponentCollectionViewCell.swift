//
//  FeatureComponentCollectionViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 06/09/23.
//

import UIKit

class FeatureComponentCollectionViewCell: UICollectionViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var iconLabel: UILabel?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Public Methods

    func setup(title: String, iconSymbol: String) {
        titleLabel?.text = title
        iconLabel?.text = iconSymbol
    }
}
