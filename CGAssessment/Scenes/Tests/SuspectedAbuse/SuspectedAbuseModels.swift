//
//  SuspectedAbuseModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import Foundation

struct SuspectedAbuseModels {

    struct ControllerViewModel {
        let selectedOption: SelectableKeys
        let textViewModel: CGAModels.TextViewViewModel
        let isResultsButtonEnabled: Bool

        var sections: [Section: [Row]] {
            let optionsForDoneSection: [Row] = isResultsButtonEnabled ? [.done] : []

            if selectedOption == .firstOption {
                return [.yes: [.option, .textView], .no: [.option], .done: optionsForDoneSection]
            }

            return [.yes: [.option], .no: [.option], .done: optionsForDoneSection]
        }
    }

    struct TestData {
        let selectedOption: SelectableKeys
        let typedText: String?
        let isDone: Bool
    }

    enum Routing: Equatable {
        case chemotherapyToxicityRisk(cgaId: UUID?)
    }

    enum Section: Int {
        case yes = 0
        case no
        case done

        var title: String? {
            switch self {
            case .yes:
                return LocalizedTable.suspectedAbuseInstruction.localized
            default:
                return nil
            }
        }
    }

    enum Row {
        case option
        case textView
        case done
    }

}
