//
//  InstructionsTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 23/09/23.
//

import UIKit

class InstructionsTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var instructionsStackView: UIStackView?

    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        instructionsStackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Public Methods

    func setup(viewModel: CGAModels.InstructionsViewModel) {
        var subviews: [SingleInstructionView] = []

        if let currentSubviews = instructionsStackView?.arrangedSubviews as? [SingleInstructionView], !currentSubviews.isEmpty {
            subviews = currentSubviews
        } else {
            for _ in 1...viewModel.instructions.count { subviews.append(SingleInstructionView()) }
        }

        var index: Int = 0
        subviews.forEach {
            $0.setup(number: viewModel.instructions[safe: index]?.number ?? -1,
                     description: viewModel.instructions[safe: index]?.description ?? "")
            index += 1
        }

        subviews.forEach { instructionsStackView?.addArrangedSubview($0) }

        instructionsStackView?.layoutIfNeeded()
    }

}
