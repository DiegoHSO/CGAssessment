//
//  VisualAcuityAssessmentModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 10/10/23.
//

import Foundation

struct VisualAcuityAssessmentModels {

    struct ControllerViewModel {
        let instructions: [CGAModels.Instruction]
        let buttons: [CGAModels.GroupedButtonViewModel]
        let question: QuestionViewModel
        let selectedOption: SelectableKeys
        let imageName: String = "visual-acuity"
        let isResultsButtonEnabled: Bool

        var sections: [Section: [Row]] {
            let optionsForFirstSection: [Row] = [.instructions, .image, .buttons, .question, .done]
            let optionsForSecondSection: [Row] = isResultsButtonEnabled ? [.done] : []

            return [.test: optionsForFirstSection, .done: optionsForSecondSection]
        }
    }

    struct QuestionViewModel {
        let question: LocalizedTable?
        let selectedOption: SelectableKeys
        let options: Options
    }

    struct TestResults {
        let selectedOption: SelectableKeys
    }

    struct TestData {
        let selectedOption: SelectableKeys
        let isDone: Bool
    }

    enum Routing {
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
    }

    enum Section: Int {
        case test
        case done
    }

    enum Row {
        case instructions
        case image
        case buttons
        case question
        case done
    }

}
