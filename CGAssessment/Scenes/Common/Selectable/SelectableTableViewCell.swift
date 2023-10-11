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
        titleLabel?.text = viewModel.title?.localized
        titleLabel?.font = .compactDisplay(withStyle: .medium, size: 16)
        titleLabel?.isHidden = viewModel.title == nil
        stackViewLeadingConstraint?.constant = viewModel.leadingConstraint
        optionsStackView?.spacing = viewModel.questionsSpacing

        var subviews: [SelectableView] = []

        if let currentSubviews = optionsStackView?.arrangedSubviews as? [SelectableView], !currentSubviews.isEmpty {
            subviews = currentSubviews
        } else {
            for _ in 1...viewModel.options.count { subviews.append(SelectableView()) }
        }

        let viewModels = viewModel.options.map {
            SelectableModels.ComponentViewModel(text: $0.value.localized,
                                                contextIdentifier: viewModel.title ?? $0.value,
                                                componentIdentifier: $0.key,
                                                delegate: viewModel.delegate,
                                                isSelected: viewModel.selectedQuestion == $0.key,
                                                textStyle: viewModel.textStyle)
        }.sorted(by: { $0.componentIdentifier < $1.componentIdentifier })

        var index: Int = 0
        subviews.forEach {
            $0.setup(viewModel: viewModels[index])
            index += 1
        }

        subviews.forEach { optionsStackView?.addArrangedSubview($0) }

        optionsStackView?.layoutIfNeeded()
    }
}
