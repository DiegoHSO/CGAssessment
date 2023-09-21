//
//  LocalizedTable.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/09/23.
//

import Foundation

protocol Localizable {
    var localized: String { get }
    var rawValue: String { get }
}

extension Localizable {
    var localized: String {
        NSLocalizedString(self.rawValue, bundle: .main, comment: "")
    }
}

enum LocalizedTable: String, Localizable {
    case cga = "cga_key"
    case home = "home_key"
    case cgas = "cgas_key"
    case preferences = "preferences_key"

    // MARK: - Dashboard

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
    case hello = "hello_key"
    case todoEvaluations = "todo_evaluations_key"
    case startNewCGA = "start_new_cga_key"
    case patients = "patients_key"
    case cgaDomains = "cga_domains_key"
    case reports = "reports_key"
    case howAreYou = "hows_going_key"

    // MARK: - New CGA

    case age = "age_key"
    case yesKey = "yes_key"
    case noKey = "no_key"
    case header = "new_cga_header_key"
    case pleaseSelect = "please_select_key"
    case pleaseFillIn = "please_fill_in_key"
    case searchPatient = "search_patient_key"
    case patientName = "patient_name_key"
    case name = "name_key"
    case birthDate = "birth_date_key"
    case gender = "gender_key"
    case female = "female_key"
    case male = "male_key"
    case start = "start_key"
    case newCga = "new_cga_key"

    // MARK: - CGA Domains

    case doneTestsSingular = "done_tests_singular_key"
    case doneTestsPlural = "done_tests_plural_key"
    case cgaDomainsTooltip = "cga_domains_tooltip_key"

    // MARK: - Domain names

    case mobility = "mobility_key"
    case cognitive = "cognitive_key"
    case sensory = "sensory_key"
    case functional = "functional_key"
    case nutricional = "nutricional_key"
    case social = "social_key"
    case polypharmacy = "polypharmacy_key"
    case comorbidity = "comorbidity_key"
    case other = "other_key"

    // MARK: - Test names

    case timedUpAndGo = "timed_up_and_go_key"
    case walkingSpeed = "walking_speed_key"
    case calfCircumference = "calf_circumference_key"
    case gripStrength = "grip_strength_key"
    case sarcopeniaAssessment = "sarcopenia_assessment_key"

    case miniMentalStateExamination = "mini_mental_state_examination_key"
    case verbalFluencyTest = "verbal_fluency_test_key"
    case clockDrawingTest = "clock_drawing_test"
    case moca = "moca_key"
    case geriatricDepressionScale = "geriatric_depression_scale_key"
    case visualAcuityAssessment = "visual_acuity_assessment_key"
    case hearingLossAssessment = "hearing_loss_assessment_key"
    case katzScale = "katz_scale_key"
    case lawtonScale = "lawton_scale_key"
    case miniNutritionalAssessment = "mini_nutritional_assessment_key"
    case apgarScale = "apgar_scale_key"
    case zaritScale = "zarit_scale_key"
    case polypharmacyCriteria = "polypharmacy_criteria_key"
    case charlsonIndex = "charlson_index_key"
    case suspectedAbuse = "suspected_abuse_key"
    case cardiovascularRiskEstimation = "cardiovascular_risk_estimation_key"
    case chemotherapyToxicityRisk = "chemotherapy_toxicity_risk_key"
}
