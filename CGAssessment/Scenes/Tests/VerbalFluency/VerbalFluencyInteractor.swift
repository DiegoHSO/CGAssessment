//
//  VerbalFluencyInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import Foundation
import OSLog

protocol VerbalFluencyLogic: ActionButtonDelegate, SelectableViewDelegate, StopwatchDelegate, StepperDelegate {
    func controllerDidLoad()
}

class VerbalFluencyInteractor: VerbalFluencyLogic {

    // MARK: - Private Properties

    private var presenter: VerbalFluencyPresentationLogic?
    private var worker: VerbalFluencyWorker?
    private var cgaId: UUID?
    private var selectedOption: SelectableKeys = .secondOption
    private var elapsedTime: TimeInterval = 60
    private var countedWords: Int16 = 0

    // MARK: - Init

    init(presenter: VerbalFluencyPresentationLogic, worker: VerbalFluencyWorker, cgaId: UUID?) {
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
        selectedOption = option
        updateDatabase()
        sendDataToPresenter()
    }

    func didStopCounting(elapsedTime: TimeInterval, identifier: String?) {
        self.elapsedTime = elapsedTime
        updateDatabase()
        sendDataToPresenter()
    }

    func didChangeValue(value: Int) {
        countedWords = Int16(value)
        updateDatabase()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> VerbalFluencyModels.ControllerViewModel {
        let instructions: [CGAModels.Instruction] = [.init(number: 1, description: LocalizedTable.verbalFluencyFirstInstruction.localized),
                                                     .init(number: 2, description: LocalizedTable.verbalFluencySecondInstruction.localized),
                                                     .init(number: 3, description: LocalizedTable.verbalFluencyThirdInstruction.localized),
                                                     .init(number: 4, description: LocalizedTable.verbalFluencyFourthInstruction.localized)]
        let question: VerbalFluencyModels.QuestionViewModel = .init(question: .miniMentalStateExamFirstQuestion, selectedOption: selectedOption,
                                                                    options: [.firstOption: .eightOrMoreYears, .secondOption: .eightOrLessYears])

        let isResultsButtonEnabled = selectedOption != .none ? true : false

        return .init(instructions: instructions, question: question, countedWords: countedWords,
                     selectedOption: selectedOption, elapsedTime: elapsedTime,
                     isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        let results = VerbalFluencyModels.TestResults(countedWords: countedWords, selectedEducationOption: selectedOption)

        presenter?.route(toRoute: .testResults(test: .verbalFluencyTest, results: results, cgaId: cgaId))
    }

    private func computeViewModelData() {
        if let verbalFluencyProgress = try? worker?.getVerbalFluencyProgress() {
            selectedOption = SelectableKeys(rawValue: verbalFluencyProgress.selectedOption) ?? .none
            elapsedTime = verbalFluencyProgress.elapsedTime as? Double ?? 60
            countedWords = verbalFluencyProgress.countedWords

            if verbalFluencyProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateVerbalFluencyProgress(with: .init(elapsedTime: elapsedTime, selectedOption: selectedOption, countedWords: countedWords, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
