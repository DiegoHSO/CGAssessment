//
//  BinaryOptionsTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/10/23.
//

import UIKit

class BinaryOptionsTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var binaryOptionsStackView: UIStackView?
    @IBOutlet private weak var stackViewLeadingConstraint: NSLayoutConstraint?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel?.isHidden = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        binaryOptionsStackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Public Methods

    func setup(viewModel: BinaryOptionsModels.BinaryOptionsViewModel) {
        titleLabel?.text = viewModel.title?.localized
        titleLabel?.font = .compactDisplay(withStyle: .medium, size: 16)
        titleLabel?.isHidden = viewModel.title == nil
        stackViewLeadingConstraint?.constant = viewModel.leadingConstraint

        var subviews: [BinaryOptionView] = []

        if let currentSubviews = binaryOptionsStackView?.arrangedSubviews as? [BinaryOptionView], !currentSubviews.isEmpty {
            subviews = currentSubviews
        } else {
            for _ in 1...viewModel.questions.count { subviews.append(BinaryOptionView()) }
        }

        let viewModels = viewModel.questions.map {
            BinaryOptionsModels.BinaryOptionViewModel(question: $0.value.question, selectedOption: $0.value.selectedOption,
                                                      firstOptionTitle: $0.key == 1 ? viewModel.firstOptionTitle : nil,
                                                      secondOptionTitle: $0.key == 1 ? viewModel.secondOptionTitle : nil,
                                                      delegate: viewModel.delegate, sectionIdentifier: viewModel.title, identifier: $0.key)
        }.sorted(by: { $0.identifier < $1.identifier })

        var index: Int = 0
        subviews.forEach {
            $0.setup(viewModel: viewModels[index])
            index += 1
        }

        subviews.forEach { binaryOptionsStackView?.addArrangedSubview($0) }

        binaryOptionsStackView?.layoutIfNeeded()
    }

}
