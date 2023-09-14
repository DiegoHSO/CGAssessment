//
//  LocalizedTable+Dashboard.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/09/23.
//

import Foundation

extension LocalizedTable {
    enum Dashboard: String, Localizable {
        case mostRecentApplication = "most_recent_application_key"
        case years = "years_key"
        case missingDomains = "missing_domains_key"
        case noMissingDomains = "no_missing_domains_key"
        case noRegisteredApplications = "no_registered_applications_key"
        case beginFirstCGA = "begin_first_cga_key"
        case seeCGAExample = "see_cga_example_key"
        case inKey = "in_key"
        case day = "day_key"
        case days = "days_key"
        case month = "month_key"
        case months = "months_key"
        case today = "today_key"
        case alteredDomain = "altered_domain_key"
        case alteredDomains = "altered_domains_key"
        case none = "none_key"
        case lastApplication = "last_application_key"
        case noReapplicationsNext = "no_reapplications_next_key"
        case upToDate = "up_to_date_key"
        case reviseCGAs = "revise_cgas_key"
        case reviseCGAsAction = "revise_cgas_action_key"
    }
}
