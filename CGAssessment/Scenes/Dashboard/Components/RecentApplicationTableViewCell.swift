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
    @IBOutlet private weak var pacientDataLabel: UILabel?
    @IBOutlet private weak var missingParametersLabel: UILabel?
    @IBOutlet private weak var progressBarView: CircularProgressBarView?
    @IBOutlet private weak var percentageLabel: UILabel?

    // MARK: - Public Methods

    func setup(pacientName: String, pacientAge: Int, missingDomains: Int) {
        let progress: Double = Double(missingDomains) / 9

        percentageLabel?.text = String(format: "%.1f", progress * 100) + "%"
        progressBarView?.progressAnimation(duration: 1, progress: progress)

        recentApplicationLabel?.text = LocalizedTable.Dashboard.mostRecentApplication.localized
        pacientDataLabel?.text = "\(pacientName), \(pacientAge) \(LocalizedTable.Dashboard.years.localized)"

        var missingParametersText: String

        if missingDomains == 0 {
            missingParametersText = LocalizedTable.Dashboard.noMissingDomains.localized
        } else {
            missingParametersText = LocalizedTable.Dashboard.missingDomains.localized.replacingOccurrences(of: "%DOMAIN_NUMBER",
                                                                                                           with: String(missingDomains))
        }

        missingParametersLabel?.text = missingParametersText
    }

}
