//
//  NoRecentApplicationTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 09/09/23.
//

import UIKit

protocol NoRecentApplicationDelegate: AnyObject {
    func didTapCallToAction()
}

class NoRecentApplicationTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var noRegisteredApplications: UILabel?
    @IBOutlet private weak var callToActionLabel: UILabel?
    @IBOutlet private weak var callToActionButton: UIButton?
    weak var delegate: NoRecentApplicationDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        setupLabels()
    }

    // MARK: - Private Methods

    @IBAction private func callToAction(_ sender: UIButton) {
        delegate?.didTapCallToAction()
    }

    private func setupViews() {
        callToActionButton?.layer.borderColor = UIColor.label3?.withAlphaComponent(0.5).cgColor
        callToActionButton?.layer.borderWidth = 2
    }

    private func setupLabels() {
        noRegisteredApplications?.text = LocalizedTable.Dashboard.noRegisteredApplications.localized
        callToActionLabel?.text = LocalizedTable.Dashboard.beginFirstCGA.localized
        callToActionButton?.setTitle(LocalizedTable.Dashboard.seeCGAExample.localized, for: .normal)
    }
}
