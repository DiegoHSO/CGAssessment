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

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel?.isHidden = true
    }

    // MARK: - Public Methods

    func setup(viewModel: SelectableModels.QuestionsViewModel) {
        titleLabel?.text = viewModel.title
        titleLabel?.isHidden = viewModel.title == nil

        var subviews: [SelectableView] = []

        if let currentSubviews = optionsStackView?.arrangedSubviews as? [SelectableView], !currentSubviews.isEmpty {
            subviews = currentSubviews
        } else {
            for _ in 1...viewModel.questions.count { subviews.append(SelectableView()) }
        }

        let viewModels = viewModel.questions.map {
            SelectableModels.ComponentViewModel(text: $0.value,
                                                identifier: $0.key,
                                                delegate: viewModel.delegate,
                                                isSelected: viewModel.selectedQuestion == $0.key)
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
