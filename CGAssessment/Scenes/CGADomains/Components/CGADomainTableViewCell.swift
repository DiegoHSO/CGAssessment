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
        super.prepareForReuse()

        testsStackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Public Methods

    func setup(viewModel: CGADomainsModels.DomainViewModel) {
        var doneTestsText = viewModel.tests.count == 1 ? LocalizedTable.doneTestsSingular.localized :
            LocalizedTable.doneTestsPlural.localized

        doneTestsText = doneTestsText.replacingOccurrences(of: "%DONE_TESTS",
                                                           with: String(viewModel.tests.filter { $0.value == true }.count))
        doneTestsText = doneTestsText.replacingOccurrences(of: "%TOTAL_TESTS",
                                                           with: String(viewModel.tests.count))
        domainNameLabel?.text = "\(viewModel.name) \(viewModel.symbol)"
        domainNameLabel?.font = .compactDisplay(withStyle: .bold, size: 16)

        doneTestsLabel?.text = doneTestsText
        doneTestsLabel?.font = .compactDisplay(withStyle: .semibold, size: 15)

        var subviews: [TestNameView] = []

        if let currentSubviews = testsStackView?.arrangedSubviews as? [TestNameView], !currentSubviews.isEmpty {
            subviews = currentSubviews
        } else {
            for _ in 1...viewModel.tests.keys.count { subviews.append(TestNameView()) }
        }

        var index: Int = 0

        viewModel.tests.forEach { (key, value) in
            subviews[safe: index]?.setup(testName: key.title, isDone: value)
            index += 1
        }

        subviews.forEach { testsStackView?.addArrangedSubview($0) }

        testsStackView?.layoutIfNeeded()
    }

}
