//
//  LawtonScaleModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

struct LawtonScaleModels {

    typealias Questions = [Section: QuestionViewModel]
    typealias RawQuestions = [LocalizedTable: SelectableKeys]
    typealias QuestionsOrder = [LocalizedTable: Int]

    struct ControllerViewModel {
        let questions: Questions
        let isResultsButtonEnabled: Bool
        var sections: [Section: [Row]] {
            let optionsForDoneSection: [Row] = isResultsButtonEnabled ? [.done] : []
            let optionsForQuestionSections: [Row] = [.question]

            return [.header: [], .firstQuestion: optionsForQuestionSections, .secondQuestion: optionsForQuestionSections,
                    .thirdQuestion: optionsForQuestionSections, .fourthQuestion: optionsForQuestionSections,
                    .fifthQuestion: optionsForQuestionSections, .sixthQuestion: optionsForQuestionSections,
                    .seventhQuestion: optionsForQuestionSections, .done: optionsForDoneSection]
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
        case header = 0
        case firstQuestion
        case secondQuestion
        case thirdQuestion
        case fourthQuestion
        case fifthQuestion
        case sixthQuestion
        case seventhQuestion
        case done

        var title: LocalizedTable {
            switch self {
            case .header: .lawtonScaleHeader
            case .done: .none
            case .firstQuestion: .telephone
            case .secondQuestion: .trips
            case .thirdQuestion: .shopping
            case .fourthQuestion: .mealPreparation
            case .fifthQuestion: .housework
            case .sixthQuestion: .medicine
            case .seventhQuestion: .money
            }
        }
    }

    enum Row {
        case question
        case done
    }

}
