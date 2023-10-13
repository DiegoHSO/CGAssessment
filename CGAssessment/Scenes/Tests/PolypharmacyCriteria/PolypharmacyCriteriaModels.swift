//
//  PolypharmacyCriteriaModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

struct PolypharmacyCriteriaModels {

    struct ControllerViewModel {
        let instructions: [CGAModels.Instruction]
        let picker: CGAModels.SheetableViewModel
        let pickerContent: [String]
        let isResultsButtonEnabled: Bool
        var sections: [Section: [Row]] {
            let optionsForDoneSection: [Row] = isResultsButtonEnabled ? [.done] : []

            return [.instructions: [.instructions], .picker: [.picker], .done: optionsForDoneSection]
        }
    }

    struct TestResults {
        let numberOfMedicines: Int16
    }

    struct TestData {
        let numberOfMedicines: Int16?
        let isDone: Bool
    }

    enum Routing {
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
        case openBottomSheet(viewModel: CGAModels.BottomSheetViewModel)
    }

    enum Section: Int {
        case instructions
        case picker
        case done

        var title: String? {
            switch self {
            case .instructions:
                LocalizedTable.instructions.localized
            default:
                nil
            }
        }
    }

    enum Row {
        case instructions
        case picker
        case done
    }

}
