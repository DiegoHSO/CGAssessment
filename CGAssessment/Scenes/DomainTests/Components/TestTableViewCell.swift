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

    func setup(viewModel: DomainTestsModels.TestViewModel) {
        titleLabel?.text = viewModel.title
        descriptionLabel?.text = viewModel.description
        statusLabel?.text = viewModel.status.title
        statusSymbolLabel?.text = viewModel.status.symbol
    }

    // MARK: - Private Methods

    private func setupViews() {
        statusSymbolLabel?.textColor = .background8?.withAlphaComponent(0.7)
        statusLabel?.textColor = .background8?.withAlphaComponent(0.7)
    }

}
