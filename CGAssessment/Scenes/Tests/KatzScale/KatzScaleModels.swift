//
//  KatzScaleModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

struct KatzScaleModels {

    typealias RawQuestions = [LocalizedTable: SelectableKeys]
    typealias QuestionsOrder = [LocalizedTable: Int]

    struct ControllerViewModel {
        let questions: [QuestionViewModel]
        let isResultsButtonEnabled: Bool
        var sections: [Section: [Row]] {
            let optionsForDoneSection: [Row] = isResultsButtonEnabled ? [.done] : []
            let optionsForQuestionSections: [Row] = [.question]

            return [.header: [], .bath: optionsForQuestionSections, .dressUp: optionsForQuestionSections, .personalHygiene: optionsForQuestionSections,
                    .transfer: optionsForQuestionSections, .continence: optionsForQuestionSections, .feeding: optionsForQuestionSections,
                    .done: optionsForDoneSection]
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
        case bath
        case dressUp
        case personalHygiene
        case transfer
        case continence
        case feeding
        case done

        var title: LocalizedTable {
            switch self {
            case .header: .questionsToPatientOrCaregiver
            case .bath: .bath
            case .dressUp: .dressUp
            case .personalHygiene: .personalHygiene
            case .transfer: .transfer
            case .continence: .continence
            case .feeding: .feeding
            case .done: .none
            }
        }
    }

    enum Row {
        case question
        case done
    }

}
