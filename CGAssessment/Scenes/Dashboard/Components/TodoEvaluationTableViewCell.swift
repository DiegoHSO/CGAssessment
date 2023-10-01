//
//  TodoEvaluationTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 08/09/23.
//

import UIKit

class TodoEvaluationTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    @IBOutlet private weak var timeLeftView: UIView?
    @IBOutlet private weak var timeLeftLabel: UILabel?
    @IBOutlet private weak var patientDataLabel: UILabel?
    @IBOutlet private weak var alteredDomainsLabel: UILabel?
    @IBOutlet private weak var lastApplicationDateLabel: UILabel?

    // MARK: - Public Properties

    func setup(nextApplicationDate: Date, patientName: String, patientAge: Int,
               alteredDomains: Int, lastApplicationDate: Date) {

        timeLeftLabel?.text = setupTimeLeftText(nextApplicationDate)
        patientDataLabel?.text = "\(patientName), \(patientAge) \(LocalizedTable.years.localized)"
        patientDataLabel?.font = .compactDisplay(withStyle: .medium, size: 15)
        alteredDomainsLabel?.attributedText = setupAlteredDomainsText(alteredDomains)
        timeLeftView?.backgroundColor = getAlteredDomainsColor(alteredDomains)

        var lastApplicationDateText = "\(LocalizedTable.lastApplication.localized) "
        lastApplicationDateText += "\(lastApplicationDate.formatted(date: .numeric, time: .omitted))"
        lastApplicationDateLabel?.text = lastApplicationDateText
        lastApplicationDateLabel?.font = .compactDisplay(withStyle: .medium, size: 15)
    }

    // MARK: - Private Properties

    private func setupTimeLeftText(_ nextApplicationDate: Date) -> String {
        let timeLeftSeconds = nextApplicationDate.timeIntervalSince(Date())
        let timeLeftDays = round(timeLeftSeconds / 86400)

        var timeLeftString: String = ""

        if timeLeftDays == 0 {
            timeLeftString = LocalizedTable.today.localized
        } else if timeLeftDays < 30 {
            timeLeftString = "\(LocalizedTable.inKey.localized) \(Int(timeLeftDays)) "
            timeLeftString += "\(timeLeftDays > 1 ? LocalizedTable.days.localized : LocalizedTable.day.localized)"
        } else if timeLeftDays >= 30 {
            let timeLeftMonths = round(timeLeftDays / 30)
            timeLeftString = "\(LocalizedTable.inKey.localized) \(Int(timeLeftMonths)) "
            timeLeftString += "\(timeLeftMonths > 1 ? LocalizedTable.months.localized : LocalizedTable.month.localized)"
        }

        return timeLeftString
    }

    private func setupAlteredDomainsText(_ alteredDomains: Int) -> NSAttributedString {
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

        let font: UIFont = .compactDisplay(withStyle: .medium, size: 15)
        let alteredDomainsString = NSAttributedString(string: alteredDomainsText,
                                                      attributes: [.font: font, .foregroundColor: alteredDomainsColor])
        let secondaryAlteredDomainsString = NSAttributedString(string: secondaryAlteredDomainsText,
                                                               attributes: [.font: font,
                                                                            .foregroundColor: UIColor.label1 ?? .clear])

        return alteredDomainsString + secondaryAlteredDomainsString
    }

    private func getAlteredDomainsColor(_ alteredDomains: Int) -> UIColor? {
        return alteredDomains == 0 ? .background7 : alteredDomains < 5 ? .background9 : .background10
    }

}
