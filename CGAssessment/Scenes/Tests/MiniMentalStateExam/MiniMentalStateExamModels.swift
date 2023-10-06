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
    typealias BinaryOptionsViewModel = BinaryOptionsModels.BinaryOptionsViewModel
    typealias BinaryOption = BinaryOptionsModels.BinaryOption

    struct ControllerViewModel {
        let questions: Questions
        let binaryQuestions: BinaryQuestions
        let firstQuestionOption: SelectableKeys
        let secondQuestionOption: SelectableKeys
        let thirdQuestionOption: SelectableKeys
        let fourthQuestionOption: SelectableKeys
        let fifthQuestionOption: SelectableKeys
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

    struct QuestionViewModel {
        let question: LocalizedTable?
        let options: Options
    }

    struct TestResults {
        let firstQuestionOption: SelectableKeys
        let secondQuestionOption: SelectableKeys
        let thirdQuestionOption: SelectableKeys
        let fourthQuestionOption: SelectableKeys
        let fifthQuestionOption: SelectableKeys
        let gender: Gender
    }

    struct TestData {
        let firstQuestionOption: SelectableKeys
        let secondQuestionOption: SelectableKeys
        let thirdQuestionOption: SelectableKeys
        let fourthQuestionOption: SelectableKeys
        let fifthQuestionOption: SelectableKeys
        let isDone: Bool
    }

    enum Routing {
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
