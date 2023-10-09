//
//  ResultsTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var resultsMainView: UIView?
    @IBOutlet private weak var resultsStackView: UIStackView?
    @IBOutlet private weak var testTitleView: UIView?
    @IBOutlet private weak var testTitleLabel: UILabel?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        setupViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        resultsStackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Public Methods

    func setup(viewModel: ResultsModels.ResultsViewModel) {
        testTitleLabel?.text = viewModel.testName.uppercased()
        resultsMainView?.backgroundColor = viewModel.resultType.color

        var subviews: [SingleResultView] = []

        if let currentSubviews = resultsStackView?.arrangedSubviews as? [SingleResultView], !currentSubviews.isEmpty {
            subviews = currentSubviews
        } else {
            for _ in 1...viewModel.results.count { subviews.append(SingleResultView()) }
        }

        var index: Int = 0
        subviews.forEach {
            $0.setup(title: viewModel.results[safe: index]?.title ?? "",
                     description: viewModel.results[safe: index]?.description ?? "")
            index += 1
        }

        subviews.forEach { resultsStackView?.addArrangedSubview($0) }

        resultsStackView?.layoutIfNeeded()
    }

    // MARK: - Private Methods

    private func setupViews() {
        testTitleView?.layer.cornerRadius = 15
        testTitleView?.layer.borderColor = UIColor.label1?.cgColor
        testTitleView?.layer.borderWidth = 1
        testTitleView?.backgroundColor = .background15

        resultsMainView?.layer.borderColor = UIColor.label3?.cgColor
        resultsMainView?.layer.borderWidth = 2
        resultsMainView?.layer.cornerRadius = 10
    }

}
