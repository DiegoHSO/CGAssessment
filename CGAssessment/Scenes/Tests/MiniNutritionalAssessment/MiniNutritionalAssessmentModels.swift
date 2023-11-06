//
//  MiniNutritionalAssessmentModels.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation

struct MiniNutritionalAssessmentModels {

    typealias Questions = [Section: [QuestionViewModel]]
    typealias RawQuestions = [LocalizedTable: SelectableKeys]
    typealias PickerContent = [LocalizedTable: [String]]

    struct ControllerViewModel {
        let questions: Questions
        let pickers: [CGAModels.SheetableViewModel]
        let height: String?
        let weight: String?
        let pickerContent: PickerContent
        let isExtraQuestionSelected: Bool
        let isResultsButtonEnabled: Bool
        var sections: [Section: [Row]] {
            let optionsForDoneSection: [Row] = isResultsButtonEnabled ? [.done] : []
            let optionsForQuestionsSection: [Row] = [.question, .question, .question, .question, .question]
            let optionsForPickerSection: [Row] = [.picker, .picker]
            let optionsForTooltipSection: [Row] = [.tooltip]
            let optionsForExtraSection: [Row] = isExtraQuestionSelected ? [.question] : []

            return [.questions: optionsForQuestionsSection, .picker: optionsForPickerSection,
                    .tooltip: optionsForTooltipSection, .extraQuestion: optionsForExtraSection,
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
        let height: Double?
        let weight: Double?
        let isExtraQuestionSelected: Bool
    }

    struct TestData {
        let questions: RawQuestions
        let height: Double?
        let weight: Double?
        let isExtraQuestionSelected: Bool
        let isDone: Bool
    }

    enum Routing: Equatable {
        case testResults(test: SingleDomainModels.Test, results: TestResults, cgaId: UUID?)
        case openBottomSheet(viewModel: CGAModels.BottomSheetViewModel)
    }

    enum Section: Int {
        case questions
        case picker
        case tooltip
        case extraQuestion
        case done

        var title: String? {
            switch self {
            case .questions:
                LocalizedTable.questionsToPatientOrCaregiver.localized
            default:
                nil
            }
        }
    }

    enum Row {
        case question
        case tooltip
        case picker
        case done
    }

}
