//
//  ClockDrawingInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import Foundation
import OSLog

protocol ClockDrawingLogic: ActionButtonDelegate, BinaryOptionDelegate {
    func controllerDidLoad()
}

class ClockDrawingInteractor: ClockDrawingLogic {

    // MARK: - Private Properties

    private var presenter: ClockDrawingPresentationLogic?
    private var worker: ClockDrawingWorker?
    private var cgaId: UUID?
    private var rawBinaryQuestions: ClockDrawingModels.RawBinaryQuestions =  [
        .outline: [1: .none, 2: .none],
        .numbers: [1: .none, 2: .none, 3: .none, 4: .none, 5: .none, 6: .none],
        .pointers: [1: .none, 2: .none, 3: .none, 4: .none, 5: .none, 6: .none]
    ]

    // MARK: - Init

    init(presenter: ClockDrawingPresentationLogic, worker: ClockDrawingWorker, cgaId: UUID?) {
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

    func didSelect(option: SelectableBinaryKeys, numberIdentifier: Int16, sectionIdentifier: LocalizedTable) {
        rawBinaryQuestions[sectionIdentifier]?.updateValue(option, forKey: numberIdentifier)

        updateDatabase()
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> ClockDrawingModels.ControllerViewModel {
        let instructions: [CGAModels.Instruction] = [.init(number: 1, description: LocalizedTable.clockDrawingFirstInstruction.localized),
                                                     .init(number: 2, description: LocalizedTable.clockDrawingSecondInstruction.localized)]

        let firstBinarySectionQuestions: [Int16: LocalizedTable] = [1: .clockDrawingFirstSectionFirstQuestion,
                                                                    2: .clockDrawingFirstSectionSecondQuestion]

        let secondBinarySectionQuestions: [Int16: LocalizedTable] = [1: .clockDrawingSecondSectionFirstQuestion,
                                                                     2: .clockDrawingSecondSectionSecondQuestion,
                                                                     3: .clockDrawingSecondSectionThirdQuestion,
                                                                     4: .clockDrawingSecondSectionFourthQuestion,
                                                                     5: .clockDrawingSecondSectionFifthQuestion,
                                                                     6: .clockDrawingSecondSectionSixthQuestion]

        let thirdBinarySectionQuestions: [Int16: LocalizedTable] = [1: .clockDrawingThirdSectionFirstQuestion,
                                                                    2: .clockDrawingThirdSectionSecondQuestion,
                                                                    3: .clockDrawingThirdSectionThirdQuestion,
                                                                    4: .clockDrawingThirdSectionFourthQuestion,
                                                                    5: .clockDrawingThirdSectionFifthQuestion,
                                                                    6: .clockDrawingThirdSectionSixthQuestion]

        let binaryQuestions: ClockDrawingModels.BinaryQuestions = [.firstBinaryQuestion:
                                                                    .init(title: nil, sectionIdentifier: .outline, options: rawBinaryQuestions[.outline] ?? [:],
                                                                          questions: firstBinarySectionQuestions, firstOptionTitle: LocalizedTable.yesKey.localized,
                                                                          secondOptionTitle: LocalizedTable.noKey.localized, delegate: self, leadingConstraint: 25),
                                                                   .secondBinaryQuestion:
                                                                    .init(title: nil, sectionIdentifier: .numbers, options: rawBinaryQuestions[.numbers] ?? [:],
                                                                          questions: secondBinarySectionQuestions, firstOptionTitle: LocalizedTable.yesKey.localized,
                                                                          secondOptionTitle: LocalizedTable.noKey.localized, delegate: self, leadingConstraint: 25),
                                                                   .thirdBinaryQuestion:
                                                                    .init(title: nil, sectionIdentifier: .pointers, options: rawBinaryQuestions[.pointers] ?? [:],
                                                                          questions: thirdBinarySectionQuestions, firstOptionTitle: LocalizedTable.yesKey.localized,
                                                                          secondOptionTitle: LocalizedTable.noKey.localized, delegate: self, leadingConstraint: 25)
        ]

        let binaryOptionsDictionaries = rawBinaryQuestions.map { $0.value }
        let selectedBinaryOptions = binaryOptionsDictionaries.reduce([]) { partialResult, dictionary in
            partialResult + dictionary.map { $0.value }
        }

        let isResultsButtonEnabled: Bool = selectedBinaryOptions.allSatisfy({ $0 != .none })

        return .init(instructions: instructions, binaryQuestions: binaryQuestions, isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        let binaryOptionsDictionaries = rawBinaryQuestions.map { $0.value }
        let selectedBinaryOptions = binaryOptionsDictionaries.reduce([]) { partialResult, dictionary in
            partialResult + dictionary.map { $0.value }
        }

        let isAllDone: Bool = selectedBinaryOptions.allSatisfy({ $0 != .none })

        if isAllDone {
            presenter?.route(toRoute: .testResults(test: .clockDrawingTest, results: .init(binaryQuestions: rawBinaryQuestions), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        if let clockDrawingProgress = try? worker?.getClockDrawingProgress() {
            guard let binaryOptions = clockDrawingProgress.binaryOptions?.allObjects as? [BinaryOption] else {
                return
            }

            binaryOptions.forEach { option in
                guard let selectedOption = SelectableBinaryKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.sectionId ?? "") else { return }
                rawBinaryQuestions[identifier]?.updateValue(selectedOption, forKey: option.optionId)
            }

            if clockDrawingProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateClockDrawingProgress(with: .init(binaryQuestions: rawBinaryQuestions, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
