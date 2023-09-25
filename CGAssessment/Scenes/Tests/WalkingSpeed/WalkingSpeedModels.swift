//
//  WalkingSpeedModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation

struct WalkingSpeedModels {

    struct ControllerViewModel {
        let instructions: [CGAModels.Instruction]
        let selectedOption: SelectableKeys
        let typedFirstTime: String?
        let typedSecondTime: String?
        let typedThirdTime: String?
        let firstStopwatchTime: TimeInterval?
        let secondStopwatchTime: TimeInterval?
        let thirdStopwatchTime: TimeInterval?

        let selectedStopwatch: SelectableStopwatch
        let isResultsButtonEnabled: Bool

        var sections: [Section: [Row]] {
            let optionsForFirstSection: [Row] = [.instructions]
            let optionsForSecondSection: [Row] = [.hasStopwatch, .firstTextFieldStopwatch, .secondTextFieldStopwatch, .thirdTextFieldStopwatch]
            var optionsForThirdSection: [Row] = [.doesNotHaveStopwatch, .firstStopwatchTooltip]
            let optionsForFourthSection: [Row] = isResultsButtonEnabled ? [.done] : []

            switch selectedStopwatch {
            case .first:
                optionsForThirdSection.append(contentsOf: [.firstStopwatch, .secondStopwatchTooltip, .thirdStopwatchTooltip])
            case .second:
                optionsForThirdSection.append(contentsOf: [.secondStopwatchTooltip, .secondStopwatch, .thirdStopwatchTooltip])
            case .third:
                optionsForThirdSection.append(contentsOf: [.secondStopwatchTooltip, .thirdStopwatchTooltip, .thirdStopwatch])
            }

            return [.instructions: optionsForFirstSection, .manualStopwatch: optionsForSecondSection,
                    .appStopwatch: optionsForThirdSection, .done: optionsForFourthSection]
        }
    }

    struct TestResults {
        let firstElapsedTime: TimeInterval
        let secondElapsedTime: TimeInterval
        let thirdElapsedTime: TimeInterval
    }

    enum Routing {
        case testResults(test: SingleDomainModels.Test, results: TestResults)
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
        case firstTextFieldStopwatch
        case secondTextFieldStopwatch
        case thirdTextFieldStopwatch
        case doesNotHaveStopwatch
        case firstStopwatchTooltip
        case secondStopwatchTooltip
        case thirdStopwatchTooltip
        case firstStopwatch
        case secondStopwatch
        case thirdStopwatch
        case done
    }

    enum SelectableStopwatch {
        case first
        case second
        case third
    }

}
