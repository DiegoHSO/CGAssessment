//
//  CharlsonIndexInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import Foundation
import OSLog

protocol CharlsonIndexLogic: ActionButtonDelegate, BinaryOptionDelegate {
    func controllerDidLoad()
}

class CharlsonIndexInteractor: CharlsonIndexLogic {

    // MARK: - Private Properties

    private var presenter: CharlsonIndexPresentationLogic?
    private var worker: CharlsonIndexWorker?
    private var cgaId: UUID?
    private var rawBinaryQuestions: CharlsonIndexModels.RawBinaryQuestions =  [
        .charlsonIndexMainQuestion: [1: .none, 2: .none, 3: .none, 4: .none, 5: .none, 6: .none,
                                     7: .none, 8: .none, 9: .none, 10: .none, 11: .none, 12: .none,
                                     13: .none, 14: .none, 15: .none, 16: .none, 17: .none, 18: .none]
    ]

    // MARK: - Init

    init(presenter: CharlsonIndexPresentationLogic, worker: CharlsonIndexWorker, cgaId: UUID?) {
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

    private func createViewModel() -> CharlsonIndexModels.ControllerViewModel {

        let binarySectionQuestions: [Int16: LocalizedTable] = [1: .charlsonIndexQuestionOne, 2: .charlsonIndexQuestionTwo,
                                                               3: .charlsonIndexQuestionThree, 4: .charlsonIndexQuestionFour,
                                                               5: .charlsonIndexQuestionFive, 6: .charlsonIndexQuestionSix,
                                                               7: .charlsonIndexQuestionSeven, 8: .charlsonIndexQuestionEight,
                                                               9: .charlsonIndexQuestionNine, 10: .charlsonIndexQuestionTen,
                                                               11: .charlsonIndexQuestionEleven, 12: .charlsonIndexQuestionTwelve,
                                                               13: .charlsonIndexQuestionThirteen, 14: .charlsonIndexQuestionFourteen,
                                                               15: .charlsonIndexQuestionFifteen, 16: .charlsonIndexQuestionSixteen,
                                                               17: .charlsonIndexQuestionSeventeen, 18: .charlsonIndexQuestionEighteen]

        let binaryQuestions: CharlsonIndexModels.BinaryQuestions = [.binaryQuestion:
                                                                        .init(title: .charlsonIndexMainQuestion, sectionIdentifier: .charlsonIndexMainQuestion, options: rawBinaryQuestions[.charlsonIndexMainQuestion] ?? [:],
                                                                              questions: binarySectionQuestions, firstOptionTitle: LocalizedTable.yesKey.localized,
                                                                              secondOptionTitle: LocalizedTable.noKey.localized, delegate: self, leadingConstraint: 30)
        ]

        let binaryOptionsDictionaries = rawBinaryQuestions.map { $0.value }
        let selectedBinaryOptions = binaryOptionsDictionaries.reduce([]) { partialResult, dictionary in
            partialResult + dictionary.map { $0.value }
        }

        let isResultsButtonEnabled: Bool = selectedBinaryOptions.allSatisfy({ $0 != .none })

        return .init(binaryQuestions: binaryQuestions, isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        let birthDate = try? worker?.getPatientBirthDate()
        let binaryOptionsDictionaries = rawBinaryQuestions.map { $0.value }
        let selectedBinaryOptions = binaryOptionsDictionaries.reduce([]) { partialResult, dictionary in
            partialResult + dictionary.map { $0.value }
        }

        let isAllDone: Bool = selectedBinaryOptions.allSatisfy({ $0 != .none })

        if isAllDone {
            presenter?.route(toRoute: .testResults(test: .charlsonIndex, results: .init(binaryQuestions: rawBinaryQuestions, patientBirthDate: birthDate), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        if let charlsonIndexProgress = try? worker?.getCharlsonIndexProgress() {
            guard let binaryOptions = charlsonIndexProgress.binaryOptions?.allObjects as? [BinaryOption] else {
                return
            }

            binaryOptions.forEach { option in
                guard let selectedOption = SelectableBinaryKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.sectionId ?? "") else { return }
                rawBinaryQuestions[identifier]?.updateValue(selectedOption, forKey: option.optionId)
            }

            if charlsonIndexProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateCharlsonIndexProgress(with: .init(binaryQuestions: rawBinaryQuestions, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
