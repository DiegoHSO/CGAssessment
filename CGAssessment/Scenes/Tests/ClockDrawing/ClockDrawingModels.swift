//
//  ClockDrawingModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import Foundation

struct ClockDrawingModels {

    typealias BinaryQuestions = [Section: BinaryOptionsViewModel]
    typealias RawBinaryQuestions = [LocalizedTable: [Int16: SelectableBinaryKeys]]
    typealias BinaryOptionsViewModel = BinaryOptionsModels.BinaryOptionsViewModel

    struct ControllerViewModel {
        let instructions: [CGAModels.Instruction]
        let binaryQuestions: BinaryQuestions
        let isResultsButtonEnabled: Bool

        var sections: [Section: [Row]] {
            let optionsForBinaryQuestions: [Row] = [.binaryQuestion]
            let optionsForFifthSection: [Row] = isResultsButtonEnabled ? [.done] : []

            return [.instructions: [.instructions], .firstBinaryQuestion: optionsForBinaryQuestions,
                    .secondBinaryQuestion: optionsForBinaryQuestions, .thirdBinaryQuestion: optionsForBinaryQuestions,
                    .done: optionsForFifthSection]
        }
    }

    struct TestResults: Equatable {
        let binaryQuestions: RawBinaryQuestions
    }

    struct TestData {
        let binaryQuestions: RawBinaryQuestions
        let isDone: Bool
    }

    enum Routing: Equatable {
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
    }

    enum Section: Int {
        case instructions
        case firstBinaryQuestion
        case secondBinaryQuestion
        case thirdBinaryQuestion
        case done
    }

    enum Row {
        case instructions
        case binaryQuestion
        case done
    }

}
