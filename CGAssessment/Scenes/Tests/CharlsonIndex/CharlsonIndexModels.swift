//
//  CharlsonIndexModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import Foundation

struct CharlsonIndexModels {

    typealias BinaryQuestions = [Section: BinaryOptionsViewModel]
    typealias RawBinaryQuestions = [LocalizedTable: [Int16: SelectableBinaryKeys]]
    typealias BinaryOptionsViewModel = BinaryOptionsModels.BinaryOptionsViewModel

    struct ControllerViewModel {
        let binaryQuestions: BinaryQuestions
        let isResultsButtonEnabled: Bool

        var sections: [Section: [Row]] {
            let optionsForBinaryQuestions: [Row] = [.binaryQuestion]
            let optionsForDoneSection: [Row] = isResultsButtonEnabled ? [.done] : []

            return [.binaryQuestion: optionsForBinaryQuestions, .done: optionsForDoneSection]
        }
    }

    struct TestResults {
        let binaryQuestions: RawBinaryQuestions
        let patientBirthDate: Date?
    }

    struct TestData {
        let binaryQuestions: RawBinaryQuestions
        let isDone: Bool
    }

    enum Routing {
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
    }

    enum Section: Int {
        case binaryQuestion
        case done

        var title: String? {
            switch self {
            case .binaryQuestion:
                return LocalizedTable.questionsToPatientOrCaregiver.localized
            default:
                return nil
            }
        }
    }

    enum Row {
        case binaryQuestion
        case done
    }

}
