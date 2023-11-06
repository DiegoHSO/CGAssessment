//
//  ZaritScaleModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 12/10/23.
//

import Foundation

struct ZaritScaleModels {

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
        case questions = 0
        case done
    }

    enum Row {
        case question
        case done
    }

}
