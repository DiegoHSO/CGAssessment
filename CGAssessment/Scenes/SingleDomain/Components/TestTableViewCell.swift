//
//  TestTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 22/09/23.
//

import UIKit

class TestTableViewCell: UITableViewCell {

    // MARK: - Private Methods

    @IBOutlet private weak var statusSymbolLabel: UILabel?
    @IBOutlet private weak var statusLabel: UILabel?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Public Methods

    func setup(viewModel: SingleDomainModels.TestViewModel) {
        titleLabel?.text = viewModel.test.title
        descriptionLabel?.text = viewModel.test.description
        statusLabel?.text = viewModel.status.title
        statusSymbolLabel?.text = viewModel.status.symbol
    }

    func setDisabledState() {
        isUserInteractionEnabled = false
        contentView.alpha = 0.4
    }

    func setEnabledState() {
        isUserInteractionEnabled = true
        contentView.alpha = 1
    }

    // MARK: - Private Methods

    private func setupViews() {
        statusSymbolLabel?.textColor = .background8?.withAlphaComponent(0.7)
        statusLabel?.textColor = .background8?.withAlphaComponent(0.7)
    }

}
