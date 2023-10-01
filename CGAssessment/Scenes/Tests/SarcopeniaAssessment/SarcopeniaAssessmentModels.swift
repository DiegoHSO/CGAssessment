//
//  SarcopeniaAssessmentModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 28/09/23.
//

import Foundation

struct SarcopeniaAssessmentModels {

    struct ControllerViewModel {
        let testsCompletionStatus: [SingleDomainModels.Test: SingleDomainModels.TestStatus]
        let testsResults: [SingleDomainModels.Test: ResultsModels.ResultType]
        var isResultsButtonEnabled: Bool {
            if let strengthTestResult = testsResults[.gripStrength], strengthTestResult == .excellent {
                return true
            }

            if testsResults[.gripStrength] != nil, let amountTestResult = testsResults[.calfCircumference],
               amountTestResult == .excellent {
                return true
            }

            if testsResults[.gripStrength] != nil, testsResults[.calfCircumference] != nil,
               testsResults[.timedUpAndGo] != nil {
                return true
            }

            if testsResults[.gripStrength] != nil, testsResults[.calfCircumference] != nil,
               testsResults[.walkingSpeed] != nil {
                return true
            }

            return false
        }

        var enabledCategories: [Section: Bool] {
            guard let amountTestStatus = testsCompletionStatus[.calfCircumference],
                  let strengthTestStatus = testsCompletionStatus[.gripStrength] else { return [:] }

            let strengthTestResult = testsResults[.gripStrength]
            let amountTestResult = testsResults[.calfCircumference]

            return [.strength: true, .quantity: strengthTestStatus == .done && strengthTestResult == .bad,
                    .performance: strengthTestStatus == .done && amountTestStatus == .done && amountTestResult == .bad]
        }

        var tests: [Section: [SingleDomainModels.Test]] {
            return [.strength: [.gripStrength], .quantity: [.calfCircumference],
                    .performance: [.timedUpAndGo, .walkingSpeed]]
        }

        var sections: [Section: [Row]] {
            let optionsForFirstSection: [Row] = [.title]
            let optionsForSecondSection: [Row] = [.test]
            let optionsForThirdSection: [Row] = [.test]
            let optionsForFourthSection: [Row] = [.test, .test]
            let optionsForFifthSection: [Row] = isResultsButtonEnabled ? [.done] : []

            return [.title: optionsForFirstSection, .strength: optionsForSecondSection,
                    .quantity: optionsForThirdSection, .performance: optionsForFourthSection,
                    .done: optionsForFifthSection]
        }
    }

    struct TestResults {
        let gripStrengthResults: GripStrengthModels.TestResults
        let calfCircumferenceResults: CalfCircumferenceModels.TestResults?
        let timedUpAndGoResults: TimedUpAndGoModels.TestResults?
        let walkingSpeedResults: WalkingSpeedModels.TestResults?
    }

    struct TestData {
        let isDone: Bool
    }

    enum Routing {
        case gripStrength(cgaId: UUID?)
        case calfCircumference(cgaId: UUID?)
        case timedUpAndGo(cgaId: UUID?)
        case walkingSpeed(cgaId: UUID?)
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
    }

    enum Section: Int {
        case title
        case strength
        case quantity
        case performance
        case done
    }

    enum Row {
        case title
        case test
        case done
    }

}
