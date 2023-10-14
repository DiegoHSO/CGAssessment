//
//  CGAsSubtitleHeaderView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import UIKit

class CGAsSubtitleHeaderView: UITableViewHeaderFooterView {

    // MARK: - Private Properties

    @IBOutlet private weak var subtitleLabel: UILabel?
    @IBOutlet private weak var finishedDomainLabel: UILabel?
    @IBOutlet private weak var incompleteDomainLabel: UILabel?
    @IBOutlet private weak var notStartedDomainLabel: UILabel?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        setupLabels()
    }

    // MARK: - Private Methods

    private func setupLabels() {
        subtitleLabel?.font = .compactDisplay(withStyle: .semibold, size: 20)
        finishedDomainLabel?.font = .compactDisplay(withStyle: .semibold, size: 15)
        incompleteDomainLabel?.font = .compactDisplay(withStyle: .semibold, size: 15)
        notStartedDomainLabel?.font = .compactDisplay(withStyle: .semibold, size: 15)
        subtitleLabel?.text = LocalizedTable.subtitle.localized
        finishedDomainLabel?.text = "􀁣 : " + LocalizedTable.finishedDomain.localized
        incompleteDomainLabel?.text = "􁜣 : " + LocalizedTable.incompleteDomain.localized
        notStartedDomainLabel?.text = "􁜟 : " + LocalizedTable.notStartedDomain.localized
    }
}
