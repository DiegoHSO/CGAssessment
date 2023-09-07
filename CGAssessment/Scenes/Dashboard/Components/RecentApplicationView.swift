//
//  RecentApplicationView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/09/23.
//

import UIKit

class RecentApplicationView: UIView {

    // MARK: - Private Properties

    @IBOutlet private var contentView: UIView?
    @IBOutlet private weak var recentApplicationLabel: UILabel?
    @IBOutlet private weak var pacientDataLabel: UILabel?
    @IBOutlet private weak var missingParametersLabel: UILabel?
    @IBOutlet private weak var progressBarView: CircularProgressBarView?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("RecentApplicationView", owner: self, options: nil)
        addSubview(contentView ?? UIView())
        contentView?.frame = self.bounds
        contentView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    // MARK: - Public Methods

    func setup(pacientName: String, pacientAge: Int, missingDomains: Int) {
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

        // TODO: Setup ProgressBar progress
    }

}
