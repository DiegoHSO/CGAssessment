//
//  VerbalFluencyModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import Foundation

struct VerbalFluencyModels {

    struct ControllerViewModel {
        let instructions: [CGAModels.Instruction]
        let question: QuestionViewModel
        let countedWords: Int16
        let selectedOption: SelectableKeys
        let elapsedTime: TimeInterval?
        let isResultsButtonEnabled: Bool

        var sections: [Section: [Row]] {
            let optionsForFirstSection: [Row] = [.instructions]
            let optionsForSecondSection: [Row] = [.stopwatch, .stepper]
            let optionsForThirdSection: [Row] = [.question]
            let optionsForFourthSection: [Row] = isResultsButtonEnabled ? [.done] : []

            return [.instructions: optionsForFirstSection, .counting: optionsForSecondSection,
                    .education: optionsForThirdSection, .done: optionsForFourthSection]
        }
    }

    struct QuestionViewModel: Equatable {
        let question: LocalizedTable?
        let selectedOption: SelectableKeys
        let options: Options
    }

    struct TestResults: Equatable {
        let countedWords: Int16
        let selectedEducationOption: SelectableKeys
    }

    struct TestData {
        let elapsedTime: TimeInterval?
        let selectedOption: SelectableKeys
        let countedWords: Int16
        let isDone: Bool
    }

    enum Routing: Equatable {
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
    }

    enum Section: Int {
        case instructions = 0
        case counting
        case education
        case done
    }

    enum Row {
        case instructions
        case stopwatch
        case stepper
        case question
        case done
    }

}
