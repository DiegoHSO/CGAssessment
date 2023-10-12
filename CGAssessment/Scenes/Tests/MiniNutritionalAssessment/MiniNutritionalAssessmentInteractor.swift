//
//  MiniNutritionalAssessmentInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation
import OSLog

protocol MiniNutritionalAssessmentLogic: ActionButtonDelegate, SelectableViewDelegate, SheetableDelegate, PickerViewDelegate {
    func controllerDidLoad()
    func didSelectTooltip()
}

class MiniNutritionalAssessmentInteractor: MiniNutritionalAssessmentLogic {

    // MARK: - Private Properties

    private var presenter: MiniNutritionalAssessmentPresentationLogic?
    private var worker: MiniNutritionalAssessmentWorker?
    private var cgaId: UUID?
    private var height: Double?
    private var weight: Double?
    private var isExtraQuestionSelected: Bool = false
    private var rawQuestions: MiniNutritionalAssessmentModels.RawQuestions = [
        .miniNutritionalAssessmentFirstQuestion: .none, .miniNutritionalAssessmentSecondQuestion: .none,
        .miniNutritionalAssessmentThirdQuestion: .none, .miniNutritionalAssessmentFourthQuestion: .none,
        .miniNutritionalAssessmentFifthQuestion: .none, .miniNutritionalAssessmentSeventhQuestion: .none
    ]
    private let heightArray: [String] = Array(0...299).map({ "\($0) cm" })
    private let weightArray: [String] = Array(stride(from: 0.0, to: 500, by: 0.5)).map { "\($0.regionFormatted()) kg" }

    // MARK: - Init

    init(presenter: MiniNutritionalAssessmentPresentationLogic, worker: MiniNutritionalAssessmentWorker, cgaId: UUID?) {
        self.presenter = presenter
        self.worker = worker
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        computeViewModelData()
        sendDataToPresenter()
    }

    func didTapActionButton(identifier: String?) {
        handleNavigation(updatesDatabase: true)
    }

    func didSelect(option: SelectableKeys, value: LocalizedTable) {
        rawQuestions[value] = option

        updateDatabase()
        sendDataToPresenter()
    }

    func didTapPicker(identifier: LocalizedTable?) {
        let selectedRow: Int
        let pickerContent: [String]

        switch identifier {
        case .height:
            selectedRow = heightArray.firstIndex(of: "\(height?.regionFormatted() ?? "0") cm") ?? 0
            pickerContent = heightArray
        case .weight:
            selectedRow = weightArray.firstIndex(of: "\(weight?.regionFormatted() ?? "0") kg") ?? 0
            pickerContent = weightArray
        default:
            selectedRow = 0
            pickerContent = []
        }

        presenter?.route(toRoute: .openBottomSheet(viewModel: .init(pickerContent: pickerContent, identifier: identifier, delegate: self, selectedRow: selectedRow)))
    }

    func didSelectTooltip() {
        isExtraQuestionSelected.toggle()

        updateDatabase()
        sendDataToPresenter()
    }

    func didSelectPickerRow(identifier: LocalizedTable?, row: Int) {
        switch identifier {
        case .height:
            let selectedHeight = heightArray[safe: row]?.replacingOccurrences(of: " cm", with: "")
            let heightAdjusted = selectedHeight?.replacingOccurrences(of: ",", with: ".")
            self.height = Double(heightAdjusted ?? "")
        case .weight:
            let selectedWeight = weightArray[safe: row]?.replacingOccurrences(of: " kg", with: "")
            let weightAdjusted = selectedWeight?.replacingOccurrences(of: ",", with: ".")
            self.weight = Double(weightAdjusted ?? "")
        default:
            return
        }

        updateDatabase()
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> MiniNutritionalAssessmentModels.ControllerViewModel {
        let questions: MiniNutritionalAssessmentModels.Questions = [.questions: [.init(question: .miniNutritionalAssessmentFirstQuestion, selectedOption: rawQuestions[.miniNutritionalAssessmentFirstQuestion] ?? .none,
                                                                                       options: [.firstOption: .miniNutritionalAssessmentQuestionOneOptionOne,
                                                                                                 .secondOption: .miniNutritionalAssessmentQuestionOneOptionTwo,
                                                                                                 .thirdOption: .miniNutritionalAssessmentQuestionOneOptionThree]),
                                                                                 .init(question: .miniNutritionalAssessmentSecondQuestion, selectedOption: rawQuestions[.miniNutritionalAssessmentSecondQuestion] ?? .none,
                                                                                       options: [.firstOption: .miniNutritionalAssessmentQuestionTwoOptionOne,
                                                                                                 .secondOption: .miniNutritionalAssessmentQuestionTwoOptionTwo,
                                                                                                 .thirdOption: .miniNutritionalAssessmentQuestionTwoOptionThree,
                                                                                                 .fourthOption: .miniNutritionalAssessmentQuestionTwoOptionFour]),
                                                                                 .init(question: .miniNutritionalAssessmentThirdQuestion, selectedOption: rawQuestions[.miniNutritionalAssessmentThirdQuestion] ?? .none,
                                                                                       options: [.firstOption: .miniNutritionalAssessmentQuestionThreeOptionOne,
                                                                                                 .secondOption: .miniNutritionalAssessmentQuestionThreeOptionTwo,
                                                                                                 .thirdOption: .miniNutritionalAssessmentQuestionThreeOptionThree]),
                                                                                 .init(question: .miniNutritionalAssessmentFourthQuestion, selectedOption: rawQuestions[.miniNutritionalAssessmentFourthQuestion] ?? .none,
                                                                                       options: [.firstOption: .yesKey,
                                                                                                 .secondOption: .noKey]),
                                                                                 .init(question: .miniNutritionalAssessmentFifthQuestion, selectedOption: rawQuestions[.miniNutritionalAssessmentFifthQuestion] ?? .none,
                                                                                       options: [.firstOption: .miniNutritionalAssessmentQuestionFiveOptionOne,
                                                                                                 .secondOption: .miniNutritionalAssessmentQuestionFiveOptionTwo,
                                                                                                 .thirdOption: .miniNutritionalAssessmentQuestionFiveOptionThree])],
                                                                    .extraQuestion: [.init(question: .miniNutritionalAssessmentSeventhQuestion, selectedOption: rawQuestions[.miniNutritionalAssessmentSeventhQuestion] ?? .none,
                                                                                           options: [.firstOption: .miniNutritionalAssessmentQuestionSixOptionOne,
                                                                                                     .secondOption: .miniNutritionalAssessmentQuestionSixOptionTwo])]
        ]

        let pickers: [CGAModels.SheetableViewModel] = [.init(title: LocalizedTable.miniNutritionalAssessmentSixthQuestion.localized,
                                                             pickerName: LocalizedTable.height, pickerValue: "\(height?.regionFormatted() ?? "0") cm", delegate: self),
                                                       .init(title: nil, pickerName: LocalizedTable.weight, pickerValue: "\(weight?.regionFormatted() ?? "0") kg", delegate: self)]

        let pickerContent: MiniNutritionalAssessmentModels.PickerContent = [.height: heightArray, .weight: weightArray]
        let isResultsButtonEnabled: Bool

        if isExtraQuestionSelected {
            let selectedOptions = rawQuestions.values.map { $0 as SelectableKeys }
            isResultsButtonEnabled = selectedOptions.allSatisfy({$0 != .none})
        } else {
            let selectedOptions = rawQuestions.filter({ $0.key != .miniNutritionalAssessmentSeventhQuestion }).values.map { $0 as SelectableKeys }
            isResultsButtonEnabled = selectedOptions.allSatisfy({$0 != .none}) && (height ?? 0) > 0 && (weight ?? 0) > 0
        }

        return .init(questions: questions, pickers: pickers, height: height?.regionFormatted(fractionDigits: 2),
                     weight: weight?.regionFormatted(fractionDigits: 2), pickerContent: pickerContent,
                     isExtraQuestionSelected: isExtraQuestionSelected, isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        let selectedOptions = rawQuestions.values.map { $0 as SelectableKeys }
        let isAllDone: Bool = selectedOptions.allSatisfy({$0 != .none})

        if isAllDone {
            presenter?.route(toRoute: .testResults(test: .miniNutritionalAssessment, results: .init(questions: rawQuestions, height: height, weight: weight, isExtraQuestionSelected: isExtraQuestionSelected), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        if let miniNutritionalAssessmentProgress = try? worker?.getMiniNutritionalAssessmentProgress() {
            guard let questionOptions = miniNutritionalAssessmentProgress.selectableOptions?.allObjects as? [SelectableOption] else {
                return
            }

            questionOptions.forEach { option in
                guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                rawQuestions[identifier] = selectedOption
            }

            height = miniNutritionalAssessmentProgress.height as? Double
            weight = miniNutritionalAssessmentProgress.weight as? Double
            isExtraQuestionSelected = miniNutritionalAssessmentProgress.isExtraQuestionSelected

            if miniNutritionalAssessmentProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateMiniNutritionalAssessmentProgress(with: .init(questions: rawQuestions, height: height, weight: weight,
                                                                            isExtraQuestionSelected: isExtraQuestionSelected, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
