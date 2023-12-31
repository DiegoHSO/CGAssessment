//
//  TimedUpAndGoModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation

struct TimedUpAndGoModels {

    struct ControllerViewModel {
        let instructions: [CGAModels.Instruction]
        let selectedOption: SelectableKeys
        let typedElapsedTime: String?
        let stopwatchElapsedTime: TimeInterval?
        let isResultsButtonEnabled: Bool

        var sections: [Section: [Row]] {
            let optionsForFirstSection: [Row] = [.instructions]
            let optionsForSecondSection: [Row] = [.hasStopwatch, .textFieldStopwatch]
            let optionsForThirdSection: [Row] = [.doesNotHaveStopwatch, .stopwatch]
            let optionsForFourthSection: [Row] = isResultsButtonEnabled ? [.done] : []

            return [.instructions: optionsForFirstSection, .manualStopwatch: optionsForSecondSection,
                    .appStopwatch: optionsForThirdSection, .done: optionsForFourthSection]
        }
    }

    struct TestResults: Equatable {
        let elapsedTime: TimeInterval
    }

    struct TestData {
        let typedElapsedTime: TimeInterval?
        let elapsedTime: TimeInterval?
        let selectedOption: SelectableKeys
        let isDone: Bool
    }

    enum Routing: Equatable {
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
    }

    enum Section: Int {
        case instructions = 0
        case manualStopwatch
        case appStopwatch
        case done
    }

    enum Row {
        case instructions
        case hasStopwatch
        case textFieldStopwatch
        case doesNotHaveStopwatch
        case stopwatch
        case done
    }

}
