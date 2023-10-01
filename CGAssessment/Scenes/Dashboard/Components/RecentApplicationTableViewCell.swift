//
//  RecentApplicationTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 09/09/23.
//

import UIKit

class RecentApplicationTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var recentApplicationLabel: UILabel?
    @IBOutlet private weak var patientDataLabel: UILabel?
    @IBOutlet private weak var missingDomainsLabel: UILabel?
    @IBOutlet private weak var progressBarView: CircularProgressBarView?
    @IBOutlet private weak var percentageLabel: UILabel?

    // MARK: - Public Methods

    func setup(patientName: String, patientAge: Int, missingDomains: Int) {
        let progress: Double = Double(missingDomains - 9) / 9

        percentageLabel?.text = (progress * 100).regionFormatted() + "%"
        percentageLabel?.font = .compactRounded(withStyle: .black, size: 15)
        progressBarView?.progressAnimation(duration: 1, progress: progress)

        recentApplicationLabel?.text = LocalizedTable.mostRecentApplication.localized
        patientDataLabel?.text = "\(patientName), \(patientAge) \(LocalizedTable.years.localized)"
        patientDataLabel?.font = .compactDisplay(withStyle: .medium, size: 15)

        var missingDomainsText: String

        if missingDomains == 0 {
            missingDomainsText = LocalizedTable.noMissingDomains.localized
        } else {
            missingDomainsText = LocalizedTable.missingDomains.localized.replacingOccurrences(of: "%DOMAIN_NUMBER",
                                                                                              with: String(missingDomains))
        }

        missingDomainsLabel?.text = missingDomainsText
        missingDomainsLabel?.font = .compactDisplay(withStyle: .medium, size: 15)
    }

}
