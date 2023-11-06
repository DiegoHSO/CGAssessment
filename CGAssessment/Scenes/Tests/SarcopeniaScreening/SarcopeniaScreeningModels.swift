//
//  SarcopeniaScreeningModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import Foundation

struct SarcopeniaScreeningModels {

    typealias Questions = [Section: QuestionViewModel]
    typealias RawQuestions = [LocalizedTable: SelectableKeys]

    struct ControllerViewModel {
        let questions: Questions
        let isResultsButtonEnabled: Bool

        var sections: [Section: [Row]] {
            let optionsForQuestionSections: [Row] = [.question]
            let optionsForSeventhSection: [Row] = isResultsButtonEnabled ? [.done] : []

            return [.title: [],
                    .firstQuestion: optionsForQuestionSections, .secondQuestion: optionsForQuestionSections,
                    .thirdQuestion: optionsForQuestionSections, .fourthQuestion: optionsForQuestionSections,
                    .fifthQuestion: optionsForQuestionSections, .sixthQuestion: optionsForQuestionSections,
                    .done: optionsForSeventhSection]
        }
    }

    struct QuestionViewModel: Equatable {
        let question: LocalizedTable?
        let selectedOption: SelectableKeys
        let options: Options
    }

    struct TestResults: Equatable {
        let questions: RawQuestions
    }

    struct TestData {
        let questions: RawQuestions
        let isDone: Bool
    }

    enum Routing: Equatable {
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
    }

    enum Section: Int {
        case title
        case firstQuestion
        case secondQuestion
        case thirdQuestion
        case fourthQuestion
        case fifthQuestion
        case sixthQuestion
        case done
    }

    enum Row {
        case question
        case done
    }

}
