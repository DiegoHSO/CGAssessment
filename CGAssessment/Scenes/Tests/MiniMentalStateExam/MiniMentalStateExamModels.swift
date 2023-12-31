//
//  MiniMentalStateExamModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/10/23.
//

import Foundation

struct MiniMentalStateExamModels {

    typealias Questions = [Section: QuestionViewModel]
    typealias BinaryQuestions = [Section: BinaryOptionsViewModel]
    typealias RawBinaryQuestions = [LocalizedTable: [Int16: SelectableBinaryKeys]]
    typealias RawQuestions = [LocalizedTable: SelectableKeys]
    typealias BinaryOptionsViewModel = BinaryOptionsModels.BinaryOptionsViewModel

    struct ControllerViewModel {
        let questions: Questions
        let binaryQuestions: BinaryQuestions
        let isResultsButtonEnabled: Bool

        var sections: [Section: [Row]] {
            let optionsForQuestionSections: [Row] = [.question]
            let optionsForBinaryQuestions: [Row] = [.binaryQuestion]
            let optionsForSeventhSection: [Row] = isResultsButtonEnabled ? [.done] : []

            return [.firstQuestion: optionsForQuestionSections, .secondQuestion: optionsForQuestionSections,
                    .thirdQuestion: optionsForQuestionSections, .fourthQuestion: optionsForQuestionSections,
                    .fifthQuestion: [.title, .image, .question], .firstBinaryQuestion: optionsForBinaryQuestions,
                    .secondBinaryQuestion: optionsForBinaryQuestions, .thirdBinaryQuestion: optionsForBinaryQuestions,
                    .fourthBinaryQuestion: optionsForBinaryQuestions, .fifthBinaryQuestion: optionsForBinaryQuestions,
                    .sixthBinaryQuestion: optionsForBinaryQuestions, .seventhBinaryQuestion: optionsForBinaryQuestions,
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
        let binaryQuestions: RawBinaryQuestions
    }

    struct TestData {
        let questions: RawQuestions
        let binaryQuestions: RawBinaryQuestions
        let isDone: Bool
    }

    enum Routing: Equatable {
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
    }

    enum Section: Int {
        case firstQuestion
        case firstBinaryQuestion
        case secondBinaryQuestion
        case thirdBinaryQuestion
        case fourthBinaryQuestion
        case fifthBinaryQuestion
        case sixthBinaryQuestion
        case secondQuestion
        case seventhBinaryQuestion
        case thirdQuestion
        case fourthQuestion
        case fifthQuestion
        case done
    }

    enum Row {
        case question
        case binaryQuestion
        case title
        case image
        case done
    }

}
