//
//  GeriatricDepressionScaleModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 09/10/23.
//

import Foundation

struct GeriatricDepressionScaleModels {

    typealias RawQuestions = [LocalizedTable: SelectableKeys]
    typealias QuestionsOrder = [LocalizedTable: Int]

    struct ControllerViewModel {
        let questions: [QuestionViewModel]
        let isResultsButtonEnabled: Bool
        var sections: [Section: [Row]] {
            let optionsForDoneSection: [Row] = isResultsButtonEnabled ? [.done] : []
            var numberOfQuestions: [Row] = []

            if !questions.isEmpty {
                for _ in 1...questions.count { numberOfQuestions.append(.question) }
            }

            return [.questions: numberOfQuestions, .done: optionsForDoneSection]
        }
    }

    struct QuestionViewModel {
        let question: LocalizedTable?
        let selectedOption: SelectableKeys
        let options: Options
    }

    struct TestResults {
        let questions: RawQuestions
    }

    struct TestData {
        let questions: RawQuestions
        let isDone: Bool
    }

    enum Routing {
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
    }

    enum Section: Int {
        case questions = 0
        case done
    }

    enum Row {
        case question
        case done
    }

}
