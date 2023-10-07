//
//  MiniMentalStateExamInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/10/23.
//

import Foundation
import OSLog

protocol MiniMentalStateExamLogic: ActionButtonDelegate, SelectableViewDelegate, BinaryOptionDelegate {
    func controllerDidLoad()
}

class MiniMentalStateExamInteractor: MiniMentalStateExamLogic {

    // MARK: - Private Properties

    private var presenter: MiniMentalStateExamPresentationLogic?
    private var worker: MiniMentalStateExamWorker?
    private var cgaId: UUID?
    private var rawBinaryQuestions: MiniMentalStateExamModels.RawBinaryQuestions =  [
        .miniMentalStateExamFirstSectionQuestion: [1: .none, 2: .none, 3: .none, 4: .none, 5: .none],
        .miniMentalStateExamSecondSectionQuestion: [1: .none, 2: .none, 3: .none, 4: .none, 5: .none],
        .miniMentalStateExamThirdSectionQuestion: [1: .none, 2: .none, 3: .none],
        .miniMentalStateExamFourthSectionQuestion: [1: .none, 2: .none, 3: .none, 4: .none, 5: .none],
        .miniMentalStateExamFifthSectionQuestion: [1: .none, 2: .none, 3: .none],
        .miniMentalStateExamSixthSectionQuestion: [1: .none, 2: .none],
        .miniMentalStateExamSeventhSectionQuestion: [1: .none, 2: .none, 3: .none]
    ]
    private var rawQuestions: MiniMentalStateExamModels.RawQuestions = [
        .miniMentalStateExamFirstQuestion: .none, .miniMentalStateExamSecondQuestion: .none,
        .miniMentalStateExamThirdQuestion: .none, .miniMentalStateExamFourthQuestion: .none,
        .miniMentalStateExamFifthQuestion: .none
    ]

    // MARK: - Init

    init(presenter: MiniMentalStateExamPresentationLogic, worker: MiniMentalStateExamWorker, cgaId: UUID?) {
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
        switch value {
        case .copiedTheDrawing, .didntCopyTheDrawing:
            rawQuestions[.miniMentalStateExamFifthQuestion] = option
        default:
            rawQuestions[value] = option
        }

        updateDatabase()
        sendDataToPresenter()
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

    private func createViewModel() -> MiniMentalStateExamModels.ControllerViewModel {

        let questions: MiniMentalStateExamModels.Questions = [.firstQuestion: .init(question: .miniMentalStateExamFirstQuestion, selectedOption: rawQuestions[.miniMentalStateExamFirstQuestion] ?? .none,
                                                                                    options: [.firstOption: .moreThanElevenYears,
                                                                                              .secondOption: .betweenNineAndElevenYears,
                                                                                              .thirdOption: .betweenFiveAndEightYears,
                                                                                              .fourthOption: .betweenOneAndFourYears, .fifthOption: .illiterate]),
                                                              .secondQuestion: .init(question: .miniMentalStateExamSecondQuestion, selectedOption: rawQuestions[.miniMentalStateExamSecondQuestion] ?? .none,
                                                                                     options: [.firstOption: .repeatedSentence,
                                                                                               .secondOption: .couldntRepeatSentence]),
                                                              .thirdQuestion: .init(question: .miniMentalStateExamThirdQuestion, selectedOption: rawQuestions[.miniMentalStateExamThirdQuestion] ?? .none,
                                                                                    options: [.firstOption: .executedTheOrder,
                                                                                              .secondOption: .didntExecuteTheOrder]),
                                                              .fourthQuestion: .init(question: .miniMentalStateExamFourthQuestion, selectedOption: rawQuestions[.miniMentalStateExamFourthQuestion] ?? .none,
                                                                                     options: [.firstOption: .wroteCorrectly,
                                                                                               .secondOption: .didntWriteCorrectly]),
                                                              .fifthQuestion: .init(question: nil, selectedOption: rawQuestions[.miniMentalStateExamFifthQuestion] ?? .none,
                                                                                    options: [.firstOption: .copiedTheDrawing,
                                                                                              .secondOption: .didntCopyTheDrawing])
        ]

        let firstBinarySectionQuestions: [Int16: LocalizedTable] = [1: .year, 2: .month, 3: .dayOfMonth, 4: .dayOfWeek, 5: .time]

        let secondBinarySectionQuestions: [Int16: LocalizedTable] = [1: .streetOrPlace, 2: .floor, 3: .neighborhoodOrNearStreet, 4: .city, 5: .state]

        let thirdBinarySectionQuestions: [Int16: LocalizedTable] = [1: .car, 2: .vase, 3: .brick]

        let fourthBinarySectionQuestions: [Int16: LocalizedTable] = [1: .firstCalculation, 2: .secondCalculation, 3: .thirdCalculation,
                                                                     4: .fourthCalculation, 5: .fifthCalculation]

        let fifthBinarySectionQuestions: [Int16: LocalizedTable] = [1: .car, 2: .vase, 3: .brick]

        let sixthBinarySectionQuestions: [Int16: LocalizedTable] = [1: .clock, 2: .pen]

        let seventhBinarySectionQuestions: [Int16: LocalizedTable] = [1: .firstStage, 2: .secondStage, 3: .thirdStage]

        let binaryQuestions: MiniMentalStateExamModels.BinaryQuestions = [.firstBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamFirstSectionQuestion, options: rawBinaryQuestions[.miniMentalStateExamFirstSectionQuestion] ?? [:],
                                                                                  questions: firstBinarySectionQuestions, firstOptionTitle: LocalizedTable.informed.localized, secondOptionTitle: LocalizedTable.didntInform.localized, delegate: self),
                                                                          .secondBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamSecondSectionQuestion, options: rawBinaryQuestions[.miniMentalStateExamSecondSectionQuestion] ?? [:],
                                                                                  questions: secondBinarySectionQuestions, firstOptionTitle: LocalizedTable.informed.localized, secondOptionTitle: LocalizedTable.didntInform.localized, delegate: self),
                                                                          .thirdBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamThirdSectionQuestion, options: rawBinaryQuestions[.miniMentalStateExamThirdSectionQuestion] ?? [:],
                                                                                  questions: thirdBinarySectionQuestions, firstOptionTitle: LocalizedTable.repeated.localized, secondOptionTitle: LocalizedTable.didntRepeat.localized, delegate: self),
                                                                          .fourthBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamFourthSectionQuestion, options: rawBinaryQuestions[.miniMentalStateExamFourthSectionQuestion] ?? [:],
                                                                                  questions: fourthBinarySectionQuestions, firstOptionTitle: LocalizedTable.gotIt.localized, secondOptionTitle: LocalizedTable.failed.localized, delegate: self),
                                                                          .fifthBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamFifthSectionQuestion, options: rawBinaryQuestions[.miniMentalStateExamFifthSectionQuestion] ?? [:],
                                                                                  questions: fifthBinarySectionQuestions, firstOptionTitle: LocalizedTable.repeated.localized, secondOptionTitle: LocalizedTable.didntRepeat.localized, delegate: self),
                                                                          .sixthBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamSixthSectionQuestion, options: rawBinaryQuestions[.miniMentalStateExamSixthSectionQuestion] ?? [:],
                                                                                  questions: sixthBinarySectionQuestions, firstOptionTitle: LocalizedTable.named.localized, secondOptionTitle: LocalizedTable.didntName.localized, delegate: self),
                                                                          .seventhBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamSeventhSectionQuestion, options: rawBinaryQuestions[.miniMentalStateExamSeventhSectionQuestion] ?? [:],
                                                                                  questions: seventhBinarySectionQuestions,
                                                                                  firstOptionTitle: LocalizedTable.carriedOut.localized,
                                                                                  secondOptionTitle: LocalizedTable.didntCarryOut.localized, delegate: self)]

        let selectedOptions = rawQuestions.values.map { $0 as SelectableKeys }
        let binaryOptionsDictionaries = rawBinaryQuestions.map { $0.value }
        let selectedBinaryOptions = binaryOptionsDictionaries.reduce([]) { _, dictionary in
            dictionary.map { $0.value }
        }

        let isResultsButtonEnabled: Bool = selectedOptions.allSatisfy({$0 != .none}) && selectedBinaryOptions.allSatisfy({ $0 != .none })

        return .init(questions: questions, binaryQuestions: binaryQuestions, isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        let selectedOptions = rawQuestions.values.map { $0 as SelectableKeys }
        let binaryOptionsDictionaries = rawBinaryQuestions.map { $0.value }
        let selectedBinaryOptions = binaryOptionsDictionaries.reduce([]) { _, dictionary in
            dictionary.map { $0.value }
        }

        let isAllDone: Bool = selectedOptions.allSatisfy({$0 != .none}) && selectedBinaryOptions.allSatisfy({ $0 != .none })

        if isAllDone {
            presenter?.route(toRoute: .testResults(test: .miniMentalStateExamination, results: .init(questions: rawQuestions, binaryQuestions: rawBinaryQuestions), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        if let miniMentalStateExamProgress = try? worker?.getMiniMentalStateExamProgress() {
            guard let binaryOptions = miniMentalStateExamProgress.binaryOptions?.allObjects as? [BinaryOption],
                  let questionOptions = miniMentalStateExamProgress.selectableOptions?.allObjects as? [SelectableOption] else {
                return
            }

            questionOptions.forEach { option in
                guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                rawQuestions[identifier] = selectedOption
            }

            binaryOptions.forEach { option in
                guard let selectedOption = SelectableBinaryKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.sectionId ?? "") else { return }
                rawBinaryQuestions[identifier]?.updateValue(selectedOption, forKey: option.optionId)
            }

            if miniMentalStateExamProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateMiniMentalStateExamProgress(with: .init(questions: rawQuestions, binaryQuestions: rawBinaryQuestions, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
