//
//  CGADomainTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 20/09/23.
//

import UIKit

class CGADomainTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var domainNameLabel: UILabel?
    @IBOutlet private weak var doneTestsLabel: UILabel?
    @IBOutlet private weak var testsStackView: UIStackView?

    // MARK: - Life Cycle

    override func prepareForReuse() {
        testsStackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Public Methods

    func setup(viewModel: CGADomainsModels.DomainViewModel) {
        var doneTestsText = viewModel.tests.count == 1 ? LocalizedTable.doneTestsSingular.localized :
            LocalizedTable.doneTestsPlural.localized

        doneTestsText = doneTestsText.replacingOccurrences(of: "%DONE_TESTS",
                                                           with: String(viewModel.tests.filter { $0.isDone == true }.count))
        doneTestsText = doneTestsText.replacingOccurrences(of: "%TOTAL_TESTS",
                                                           with: String(viewModel.tests.count))
        domainNameLabel?.text = "\(viewModel.name) \(viewModel.symbol)"
        doneTestsLabel?.text = doneTestsText

        var subviews: [TestNameView] = []

        if let currentSubviews = testsStackView?.arrangedSubviews as? [TestNameView], !currentSubviews.isEmpty {
            subviews = currentSubviews
        } else {
            for _ in 1...viewModel.tests.count { subviews.append(TestNameView()) }
        }

        var index: Int = 0
        subviews.forEach {
            $0.setup(testName: viewModel.tests[safe: index]?.name ?? "",
                     isDone: viewModel.tests[safe: index]?.isDone ?? false)
            index += 1
        }

        subviews.forEach { testsStackView?.addArrangedSubview($0) }

        testsStackView?.layoutIfNeeded()
    }

}