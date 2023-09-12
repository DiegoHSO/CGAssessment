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
    @IBOutlet private weak var pacientDataLabel: UILabel?
    @IBOutlet private weak var alteredDomainsLabel: UILabel?
    @IBOutlet private weak var lastApplicationDateLabel: UILabel?

    // MARK: - Public Properties

    func setup(nextApplicationDate: Date, pacientName: String, pacientAge: Int,
               alteredDomains: Int, lastApplicationDate: Date) {

        timeLeftLabel?.text = setupTimeLeftText(nextApplicationDate)
        pacientDataLabel?.text = "\(pacientName), \(pacientAge) \(LocalizedTable.Dashboard.years.localized)"
        alteredDomainsLabel?.attributedText = setupAlteredDomainsText(alteredDomains)
        timeLeftView?.backgroundColor = getAlteredDomainsColor(alteredDomains)

        var lastApplicationDateText = "\(LocalizedTable.Dashboard.lastApplication.localized) "
        lastApplicationDateText += "\(lastApplicationDate.formatted(date: .numeric, time: .omitted))"
        lastApplicationDateLabel?.text = lastApplicationDateText
    }

    // MARK: - Private Properties

    private func setupTimeLeftText(_ nextApplicationDate: Date) -> String {
        let timeLeftSeconds = nextApplicationDate.timeIntervalSince(Date())
        let timeLeftDays = round(timeLeftSeconds / 86400)

        var timeLeftString: String = ""

        if timeLeftDays == 0 {
            timeLeftString = LocalizedTable.Dashboard.today.localized
        } else if timeLeftDays < 30 {
            timeLeftString = "\(LocalizedTable.Dashboard.inKey.localized) \(Int(timeLeftDays)) "
            timeLeftString += "\(timeLeftDays > 1 ? LocalizedTable.Dashboard.days.localized : LocalizedTable.Dashboard.day.localized)"
        } else if timeLeftDays > 30 {
            let timeLeftMonths = round(timeLeftDays / 30)
            timeLeftString = "\(LocalizedTable.Dashboard.inKey.localized) \(Int(timeLeftMonths)) "
            timeLeftString += "\(timeLeftMonths > 1 ? LocalizedTable.Dashboard.months.localized : LocalizedTable.Dashboard.month.localized)"
        }

        return timeLeftString
    }

    private func setupAlteredDomainsText(_ alteredDomains: Int) -> NSAttributedString {
        var alteredDomainsText: String = ""
        var secondaryAlteredDomainsText: String = " \(LocalizedTable.Dashboard.alteredDomain.localized)"
        var alteredDomainsColor: UIColor = .clear

        if alteredDomains == 0 {
            alteredDomainsText = "\(LocalizedTable.Dashboard.none.localized)"
            secondaryAlteredDomainsText = " \(LocalizedTable.Dashboard.alteredDomain.localized)"
            alteredDomainsColor = UIColor(named: "Label-4") ?? .clear
        } else {
            alteredDomainsText = "\(alteredDomains)"
            secondaryAlteredDomainsText = " \(alteredDomains == 1 ? secondaryAlteredDomainsText : LocalizedTable.Dashboard.alteredDomains.localized)"
            alteredDomainsColor = UIColor(named: alteredDomains < 5 ? "Label-5" : "Label-6") ?? .clear
        }

        let font: UIFont = UIFont(name: "SFCompactDisplay-Medium", size: 15) ?? .systemFont(ofSize: 15)
        let alteredDomainsString = NSAttributedString(string: alteredDomainsText,
                                                      attributes: [.font: font, .foregroundColor: alteredDomainsColor])
        let secondaryAlteredDomainsString = NSAttributedString(string: secondaryAlteredDomainsText,
                                                               attributes: [.font: font,
                                                                            .foregroundColor: UIColor(named: "Label-1") ?? .clear])

        return alteredDomainsString + secondaryAlteredDomainsString
    }

    private func getAlteredDomainsColor(_ alteredDomains: Int) -> UIColor? {
        return UIColor(named: alteredDomains == 0 ? "Background-7" : alteredDomains < 5 ? "Background-9" : "Background-10") ?? .clear
    }

}
