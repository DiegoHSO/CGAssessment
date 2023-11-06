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
            let optionsForFirstSection: [Row] = [.instructions, .image, .buttons, .question]
            let optionsForSecondSection: [Row] = isResultsButtonEnabled ? [.done] : []

            return [.header: [.header], .test: optionsForFirstSection, .done: optionsForSecondSection]
        }
    }

    struct QuestionViewModel: Equatable {
        let question: LocalizedTable?
        let selectedOption: SelectableKeys
        let options: Options
    }

    struct TestResults: Equatable {
        let selectedOption: SelectableKeys
    }

    struct TestData {
        let selectedOption: SelectableKeys
        let isDone: Bool
    }

    enum Routing: Equatable {
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
        case printing(fileURL: URL?)
        case pdfSaving(pdfData: URL?)
    }

    enum Section: Int {
        case header
        case test
        case done
    }

    enum Row {
        case header
        case instructions
        case image
        case buttons
        case question
        case done
    }
}
