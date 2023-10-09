//
//  CGATableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 01/10/23.
//

import UIKit

class CGATableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet weak var cgaTitleLabel: UILabel?
    @IBOutlet weak var lastEditedLabel: UILabel?
    @IBOutlet weak var domainsStackView: UIStackView?

    // MARK: - Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        domainsStackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Public Methods

    func setup(viewModel: CGAsModels.CGAViewModel) {
        var cgaText = LocalizedTable.cgaName.localized

        if let patientName = viewModel.patientName {
            cgaText = LocalizedTable.cgaNameWithName.localized
            cgaText = cgaText.replacingOccurrences(of: "%PATIENT_NAME", with: patientName)
        }

        cgaTitleLabel?.text = cgaText
        cgaTitleLabel?.font = .compactDisplay(withStyle: .bold, size: 16)
        lastEditedLabel?.text = "\(LocalizedTable.lastModified.localized) \(viewModel.lastEditedDate.formatted(date: .numeric, time: .omitted))"
        lastEditedLabel?.font = .compactDisplay(withStyle: .semibold, size: 14)

        var subviews: [DomainStatusView] = []

        if let currentSubviews = domainsStackView?.arrangedSubviews as? [DomainStatusView], !currentSubviews.isEmpty {
            subviews = currentSubviews
        } else {
            for _ in 1...viewModel.domainsStatus.keys.count { subviews.append(DomainStatusView()) }
        }

        var index: Int = 0

        let sortedTests = viewModel.domainsStatus.sorted(by: { $0.key.rawValue < $1.key.rawValue })
        sortedTests.forEach { (key, value) in
            subviews[safe: index]?.setup(domainName: key.title, status: value)
            index += 1
        }

        subviews.forEach { domainsStackView?.addArrangedSubview($0) }

        domainsStackView?.layoutIfNeeded()
    }

}
