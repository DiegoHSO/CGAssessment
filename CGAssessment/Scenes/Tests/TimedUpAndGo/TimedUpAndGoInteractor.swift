//
//  TimedUpAndGoInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation
import OSLog

protocol TimedUpAndGoLogic: ActionButtonDelegate, SelectableViewDelegate, StopwatchDelegate, TextFieldDelegate {
    func controllerDidLoad()
}

class TimedUpAndGoInteractor: TimedUpAndGoLogic {

    // MARK: - Private Properties

    private var presenter: TimedUpAndGoPresentationLogic?
    private var worker: TimedUpAndGoWorker?
    private var cgaId: UUID?
    private var selectedOption: SelectableKeys = .secondOption
    private var stopwatchElapsedTime: TimeInterval?
    private var typedElapsedTime: TimeInterval?

    // MARK: - Init

    init(presenter: TimedUpAndGoPresentationLogic, worker: TimedUpAndGoWorker, cgaId: UUID?) {
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
        stopwatchElapsedTime = elapsedTime
        updateDatabase()
        sendDataToPresenter()
    }

    func didChangeText(text: String, identifier: LocalizedTable?) {
        typedElapsedTime = TimeInterval(text.replacingOccurrences(of: ",", with: "."))
        updateDatabase()
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> TimedUpAndGoModels.ControllerViewModel {
        var isResultsButtonEnabled: Bool = false
        let instructions: [CGAModels.Instruction] = [.init(number: 1, description: LocalizedTable.timedUpAndGoFirstInstruction.localized),
                                                     .init(number: 2, description: LocalizedTable.timedUpAndGoSecondInstruction.localized),
                                                     .init(number: 3, description: LocalizedTable.timedUpAndGoThirdInstruction.localized),
                                                     .init(number: 4, description: LocalizedTable.timedUpAndGoFourthInstruction.localized)]

        if let typedElapsedTime, selectedOption == .firstOption {
            isResultsButtonEnabled = typedElapsedTime > 0 ? true : false
        } else if let stopwatchElapsedTime, selectedOption == .secondOption {
            isResultsButtonEnabled = stopwatchElapsedTime > 0 ? true : false
        }

        return TimedUpAndGoModels.ControllerViewModel(instructions: instructions, selectedOption: selectedOption,
                                                      typedElapsedTime: typedElapsedTime?.regionFormatted(fractionDigits: 2),
                                                      stopwatchElapsedTime: stopwatchElapsedTime,
                                                      isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        if selectedOption == .firstOption {
            guard let typedElapsedTime else { return }
            let results = TimedUpAndGoModels.TestResults(elapsedTime: typedElapsedTime)

            presenter?.route(toRoute: .testResults(test: .timedUpAndGo, results: results, cgaId: cgaId))
        } else {
            guard let stopwatchElapsedTime else { return }
            let results = TimedUpAndGoModels.TestResults(elapsedTime: stopwatchElapsedTime)

            presenter?.route(toRoute: .testResults(test: .timedUpAndGo, results: results, cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        if let timedUpAndGoProgress = try? worker?.getTimedUpAndGoProgress() {
            selectedOption = timedUpAndGoProgress.hasStopwatch ? .firstOption : .secondOption
            stopwatchElapsedTime = timedUpAndGoProgress.measuredTime as? Double
            typedElapsedTime = timedUpAndGoProgress.typedTime as? Double

            if timedUpAndGoProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateTimedUpAndGoProgress(with: .init(typedElapsedTime: typedElapsedTime,
                                                               elapsedTime: stopwatchElapsedTime,
                                                               selectedOption: selectedOption,
                                                               isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
