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
        let isResultsButtonEnabled: Bool

        var enabledCategories: [Section: Bool] {
            guard let amountTestStatus = testsCompletionStatus[.calfCircumference],
                  let strengthTestStatus = testsCompletionStatus[.gripStrength] else { return [:] }

            let strengthTestResult = testsResults[.gripStrength]
            let amountTestResult = testsResults[.calfCircumference]

            return [.strength: true, .quantity: strengthTestStatus == .done && strengthTestResult == .bad,
                    .performance: strengthTestStatus == .done && amountTestStatus == .done &&  amountTestResult == .bad]
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
        let calfCircumferenceResults: CalfCircumferenceModels.TestResults? = nil
        let timedUpAndGoResults: TimedUpAndGoModels.TestResults? = nil
        let walkingSpeedResults: WalkingSpeedModels.TestResults? = nil
    }

    enum Routing {
        case gripStrength
        case calfCircumference
        case timedUpAndGo
        case walkingSpeed
        case testResults(test: SingleDomainModels.Test, results: TestResults)
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
