//
//  CalfCircumferenceModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import Foundation

struct CalfCircumferenceModels {

    struct ControllerViewModel {
        let instructions: [CGAModels.Instruction]
        let typedCircumference: String?
        let imageName: String?
        let isResultsButtonEnabled: Bool

        var sections: [Section: [Row]] {
            let optionsForFirstSection: [Row] = [.instructions, .image]
            let optionsForSecondSection: [Row] = [.textField]
            let optionsForThirdSection: [Row] = isResultsButtonEnabled ? [.done] : []

            return [.instructions: optionsForFirstSection, .circumference: optionsForSecondSection, .done: optionsForThirdSection]
        }
    }

    struct TestResults: Equatable {
        let circumference: Double
    }

    struct TestData {
        let circumference: Double?
        let isDone: Bool
    }

    enum Routing: Equatable {
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
    }

    enum Section: Int {
        case instructions = 0
        case circumference
        case done
    }

    enum Row {
        case instructions
        case image
        case textField
        case done
    }

}
