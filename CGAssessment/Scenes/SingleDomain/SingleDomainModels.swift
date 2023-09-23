//
//  SingleDomainModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 22/09/23.
//

import Foundation

struct SingleDomainModels {

    struct ControllerViewModel {
        let domain: CGADomainsModels.Domain
        let tests: [TestViewModel]
        let sections: Int
    }

    struct TestViewModel {
        let test: Test
        let status: TestStatus
    }

    enum TestStatus: CaseIterable {
        case done
        case incomplete
        case notStarted

        var title: String {
            switch self {
            case .done:
                return LocalizedTable.done.localized
            case .incomplete:
                return LocalizedTable.incomplete.localized
            case .notStarted:
                return LocalizedTable.notStarted.localized
            }
        }

        var symbol: String {
            switch self {
            case .done:
                return "􀁣"
            case .incomplete:
                return "􀁝"
            case .notStarted:
                return "􀁡"
            }
        }
    }

    enum Test {
        case timedUpAndGo
        case walkingSpeed
        case calfCircumference
        case gripStrength
        case sarcopeniaAssessment
        case miniMentalStateExamination
        case verbalFluencyTest
        case clockDrawingTest
        case moca
        case geriatricDepressionScale
        case visualAcuityAssessment
        case hearingLossAssessment
        case katzScale
        case lawtonScale
        case miniNutritionalAssessment
        case apgarScale
        case zaritScale
        case polypharmacyCriteria
        case charlsonIndex
        case suspectedAbuse
        case cardiovascularRiskEstimation
        case chemotherapyToxicityRisk

        var title: String {
            switch self {
            case .timedUpAndGo:
                LocalizedTable.timedUpAndGo.localized
            case .walkingSpeed:
                LocalizedTable.walkingSpeed.localized
            case .calfCircumference:
                LocalizedTable.calfCircumference.localized
            case .gripStrength:
                LocalizedTable.gripStrength.localized
            case .sarcopeniaAssessment:
                LocalizedTable.sarcopeniaAssessment.localized
            case .miniMentalStateExamination:
                LocalizedTable.miniMentalStateExamination.localized
            case .verbalFluencyTest:
                LocalizedTable.verbalFluencyTest.localized
            case .clockDrawingTest:
                LocalizedTable.clockDrawingTest.localized
            case .moca:
                LocalizedTable.moca.localized
            case .geriatricDepressionScale:
                LocalizedTable.geriatricDepressionScale.localized
            case .visualAcuityAssessment:
                LocalizedTable.visualAcuityAssessment.localized
            case .hearingLossAssessment:
                LocalizedTable.hearingLossAssessment.localized
            case .katzScale:
                LocalizedTable.katzScale.localized
            case .lawtonScale:
                LocalizedTable.lawtonScale.localized
            case .miniNutritionalAssessment:
                LocalizedTable.miniNutritionalAssessment.localized
            case .apgarScale:
                LocalizedTable.apgarScale.localized
            case .zaritScale:
                LocalizedTable.zaritScale.localized
            case .polypharmacyCriteria:
                LocalizedTable.polypharmacyCriteria.localized
            case .charlsonIndex:
                LocalizedTable.charlsonIndex.localized
            case .suspectedAbuse:
                LocalizedTable.suspectedAbuse.localized
            case .cardiovascularRiskEstimation:
                LocalizedTable.cardiovascularRiskEstimation.localized
            case .chemotherapyToxicityRisk:
                LocalizedTable.chemotherapyToxicityRisk.localized
            }
        }

        var description: String {
            switch self {
            case .timedUpAndGo:
                LocalizedTable.timedUpAndGoDescription.localized
            case .walkingSpeed:
                LocalizedTable.walkingSpeedDescription.localized
            case .calfCircumference:
                LocalizedTable.calfCircumferenceDescription.localized
            case .gripStrength:
                LocalizedTable.gripStrengthDescription.localized
            case .sarcopeniaAssessment:
                LocalizedTable.sarcopeniaAssessmentDescription.localized
            case .miniMentalStateExamination:
                LocalizedTable.miniMentalStateExaminationDescription.localized
            case .verbalFluencyTest:
                LocalizedTable.verbalFluencyTestDescription.localized
            case .clockDrawingTest:
                LocalizedTable.clockDrawingTestDescription.localized
            case .moca:
                LocalizedTable.mocaDescription.localized
            case .geriatricDepressionScale:
                LocalizedTable.geriatricDepressionScaleDescription.localized
            case .visualAcuityAssessment:
                LocalizedTable.visualAcuityAssessmentDescription.localized
            case .hearingLossAssessment:
                LocalizedTable.hearingLossAssessmentDescription.localized
            case .katzScale:
                LocalizedTable.katzScaleDescription.localized
            case .lawtonScale:
                LocalizedTable.lawtonScaleDescription.localized
            case .miniNutritionalAssessment:
                LocalizedTable.miniNutritionalAssessmentDescription.localized
            case .apgarScale:
                LocalizedTable.apgarScaleDescription.localized
            case .zaritScale:
                LocalizedTable.zaritScaleDescription.localized
            case .polypharmacyCriteria:
                LocalizedTable.polypharmacyCriteriaDescription.localized
            case .charlsonIndex:
                LocalizedTable.charlsonIndexDescription.localized
            case .suspectedAbuse:
                LocalizedTable.suspectedAbuseDescription.localized
            case .cardiovascularRiskEstimation:
                LocalizedTable.cardiovascularRiskEstimationDescription.localized
            case .chemotherapyToxicityRisk:
                LocalizedTable.chemotherapyToxicityRiskDescription.localized
            }
        }
    }

    enum Routing {
        case domainTest(test: Test)
    }
}