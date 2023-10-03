//
//  PatientTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 03/10/23.
//

import UIKit

class PatientTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var patientNameLabel: UILabel?
    @IBOutlet private weak var patientAgeLabel: UILabel?
    @IBOutlet private weak var cgaStatusLabel: UILabel?
    @IBOutlet private weak var alteredDomainsLabel: UILabel?
    @IBOutlet private weak var patientGenderImageView: UIImageView?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Public Methods

    func setup(viewModel: PatientsModels.PatientViewModel) {
        patientNameLabel?.text = viewModel.name
        patientAgeLabel?.text = "\(viewModel.birthDate.yearSinceCurrentDate) \(LocalizedTable.years.localized)"
        patientGenderImageView?.image = viewModel.gender.image
        cgaStatusLabel?.attributedText = getCGAStatusAttributedText(hasCGAInProgress: viewModel.hasCGAInProgress,
                                                                    lastCGADate: viewModel.lastCGADate)
        alteredDomainsLabel?.attributedText = getAlteredDomainsAttributedText(alteredDomains: viewModel.alteredDomains, 
                                                                              hasCGAInProgress: viewModel.hasCGAInProgress)

    }

    // MARK: - Private Methods

    private func setupViews() {
        patientNameLabel?.font = .compactDisplay(withStyle: .semibold, size: 20)
        patientAgeLabel?.font = .compactDisplay(withStyle: .semibold, size: 15)
    }

    private func getCGAStatusAttributedText(hasCGAInProgress: Bool, lastCGADate: Date?) -> NSAttributedString {
        let semiboldFont: UIFont = .compactDisplay(withStyle: .semibold, size: 15)
        let mediumFont: UIFont = .compactDisplay(withStyle: .medium, size: 15)
        let textColor: UIColor = .label1 ?? .clear
        let semiboldString = hasCGAInProgress ? LocalizedTable.has.localized : lastCGADate?.formatted(date: .numeric, time: .omitted) ?? ""
        let mediumString = hasCGAInProgress ? LocalizedTable.cgaInProgress.localized : LocalizedTable.lastApplication.localized

        let semiboldAttString = NSAttributedString(string: "\(semiboldString) ",
                                                   attributes: [.font: semiboldFont, .foregroundColor: textColor])
        let mediumAttString = NSAttributedString(string: "\(mediumString) ",
                                                 attributes: [.font: mediumFont, .foregroundColor: textColor])

        return hasCGAInProgress ? semiboldAttString + mediumAttString : mediumAttString + semiboldAttString
    }

    private func getAlteredDomainsAttributedText(alteredDomains: Int, hasCGAInProgress: Bool) -> NSAttributedString {
        var alteredDomainsText: String = ""
        var secondaryAlteredDomainsText: String = "\(LocalizedTable.alteredDomain.localized)"
        var alteredDomainsColor: UIColor = .clear

        if alteredDomains == 0 {
            alteredDomainsText = "\(LocalizedTable.none.localized) "
            secondaryAlteredDomainsText = "\(LocalizedTable.alteredDomain.localized)"
            alteredDomainsColor = .label4 ?? .clear
        } else {
            alteredDomainsText = DashboardModels.Number(rawValue: alteredDomains)?.unabbreviated ?? ""
            secondaryAlteredDomainsText = " \(alteredDomains == 1 ? secondaryAlteredDomainsText : LocalizedTable.alteredDomains.localized)"
            alteredDomainsColor = (alteredDomains < 5 ? .label5 : .label6) ?? .clear
        }

        secondaryAlteredDomainsText += hasCGAInProgress ? " \(LocalizedTable.untilNow.localized)" : ""

        let alteredDomainsFont: UIFont = .compactDisplay(withStyle: .medium, size: 15)
        let secondaryAlteredDomainsFont: UIFont = .compactDisplay(withStyle: .medium, size: 15)
        let alteredDomainsString = NSAttributedString(string: alteredDomainsText,
                                                      attributes: [.font: alteredDomainsFont, .foregroundColor: alteredDomainsColor])
        let secondaryAlteredDomainsString = NSAttributedString(string: secondaryAlteredDomainsText,
                                                               attributes: [.font: secondaryAlteredDomainsFont,
                                                                            .foregroundColor: UIColor.label1 ?? .clear])

        return alteredDomainsString + secondaryAlteredDomainsString
    }

}
