//
//  GripStrengthModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import Foundation

struct GripStrengthModels {

    struct ControllerViewModel {
        let instructions: [CGAModels.Instruction]
        let typedFirstMeasurement: String?
        let typedSecondMeasurement: String?
        let typedThirdMeasurement: String?
        let imageName: String?
        let isResultsButtonEnabled: Bool

        var sections: [Section: [Row]] {
            let optionsForFirstSection: [Row] = [.instructions, .image]
            let optionsForSecondSection: [Row] = [.firstTextField, .secondTextField, .thirdTextField]
            let optionsForThirdSection: [Row] = isResultsButtonEnabled ? [.done] : []

            return [.instructions: optionsForFirstSection, .measurement: optionsForSecondSection, .done: optionsForThirdSection]
        }
    }

    struct TestResults {
        let firstMeasurement: Double
        let secondMeasurement: Double
        let thirdMeasurement: Double
    }

    enum Routing {
        case testResults(test: SingleDomainModels.Test, results: TestResults)
    }

    enum Section: Int {
        case instructions = 0
        case measurement
        case done
    }

    enum Row {
        case instructions
        case image
        case firstTextField
        case secondTextField
        case thirdTextField
        case done
    }

}
