//
//  HearingLossAssessmentModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

struct HearingLossAssessmentModels {

    struct ControllerViewModel {
        let instructions: [CGAModels.Instruction]
        let isResultsButtonEnabled: Bool

        var sections: [Section: [Row]] {
            let optionsForFirstSection: [Row] = [.instructions]
            let optionsForSecondSection: [Row] = isResultsButtonEnabled ? [.done] : []

            return [.header: [.header], .test: optionsForFirstSection, .done: optionsForSecondSection]
        }
    }

    struct TestData {
        let isDone: Bool
    }

    enum Routing: Equatable {
        case katzScale(cgaId: UUID?)
    }

    enum Section: Int {
        case header
        case test
        case done
    }

    enum Row {
        case header
        case instructions
        case done
    }
}
