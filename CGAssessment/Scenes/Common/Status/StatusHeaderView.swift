//
//  StatusHeaderView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 04/10/23.
//

import UIKit

class StatusHeaderView: UITableViewHeaderFooterView {

    // MARK: - Private Properties

    @IBOutlet private weak var currentCGALabel: UILabel?
    @IBOutlet private weak var patientDataLabel: UILabel?
    @IBOutlet private weak var creationDateLabel: UILabel?
    @IBOutlet private weak var lastModifiedLabel: UILabel?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        setupLabels()
    }

    // MARK: - Public Methods

    func setup(viewModel: CGAModels.StatusViewModel) {
        patientDataLabel?.text = viewModel.patientName == nil ? LocalizedTable.exampleCGA.localized :
            "\(viewModel.patientName ?? ""), \(viewModel.patientBirthDate?.yearSinceCurrentDate ?? 0) \(LocalizedTable.years.localized)"
        creationDateLabel?.attributedText = getAttributedString(mediumText: LocalizedTable.createdOn.localized,
                                                                semiboldText: viewModel.cgaCreationDate.formatted(date: .numeric, time: .omitted))
        lastModifiedLabel?.attributedText = getAttributedString(mediumText: LocalizedTable.lastModified.localized,
                                                                semiboldText: viewModel.cgaLastModifiedDate.formatted(date: .numeric, time: .omitted))
    }

    // MARK: - Private Methods

    private func setupLabels() {
        currentCGALabel?.text = LocalizedTable.currentCGA.localized
        currentCGALabel?.font = .compactDisplay(withStyle: .semibold, size: 20)
        patientDataLabel?.font = .compactDisplay(withStyle: .semibold, size: 15)
    }

    private func getAttributedString(mediumText: String, semiboldText: String) -> NSAttributedString {
        let semiboldFont: UIFont = .compactDisplay(withStyle: .semibold, size: 15)
        let mediumFont: UIFont = .compactDisplay(withStyle: .medium, size: 15)
        let mediumTextColor: UIColor = .label1 ?? .clear
        let semiboldTextColor: UIColor = .label3 ?? .clear

        let semiboldAttString = NSAttributedString(string: "\(semiboldText)",
                                                   attributes: [.font: semiboldFont, .foregroundColor: semiboldTextColor])
        let mediumAttString = NSAttributedString(string: "\(mediumText) ",
                                                 attributes: [.font: mediumFont, .foregroundColor: mediumTextColor])

        return mediumAttString + semiboldAttString
    }

}
