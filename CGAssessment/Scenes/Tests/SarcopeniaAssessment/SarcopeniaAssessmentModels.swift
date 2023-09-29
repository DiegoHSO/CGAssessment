//
//  SarcopeniaAssessmentModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 28/09/23.
//

import Foundation

struct SarcopeniaAssessmentModels {

    struct ControllerViewModel {
        let testsStatus: [SingleDomainModels.Test: SingleDomainModels.TestStatus]
        let isResultsButtonEnabled: Bool

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
        let gender: Gender
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
