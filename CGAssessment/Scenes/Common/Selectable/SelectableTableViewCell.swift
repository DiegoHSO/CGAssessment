//
//  SelectableTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 14/09/23.
//

import UIKit

class SelectableTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var optionsStackView: UIStackView?
    @IBOutlet private weak var stackViewLeadingConstraint: NSLayoutConstraint?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel?.isHidden = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        optionsStackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Public Methods

    func setup(viewModel: SelectableModels.OptionsViewModel) {
        titleLabel?.text = viewModel.title
        titleLabel?.isHidden = viewModel.title == nil
        stackViewLeadingConstraint?.constant = viewModel.leadingConstraint

        var subviews: [SelectableView] = []

        if let currentSubviews = optionsStackView?.arrangedSubviews as? [SelectableView], !currentSubviews.isEmpty {
            subviews = currentSubviews
        } else {
            for _ in 1...viewModel.options.count { subviews.append(SelectableView()) }
        }

        let viewModels = viewModel.options.map {
            SelectableModels.ComponentViewModel(textKey: $0.value,
                                                identifier: $0.key,
                                                delegate: viewModel.delegate,
                                                isSelected: viewModel.selectedQuestion == $0.key,
                                                textStyle: viewModel.textStyle)
        }.sorted(by: { $0.identifier < $1.identifier })

        var index: Int = 0
        subviews.forEach {
            $0.setup(viewModel: viewModels[index])
            index += 1
        }

        subviews.forEach { optionsStackView?.addArrangedSubview($0) }

        optionsStackView?.layoutIfNeeded()
    }
}
