//
//  TimedUpAndGoInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation

protocol TimedUpAndGoLogic: ActionButtonDelegate, SelectableViewDelegate, StopwatchDelegate, TextFieldDelegate {
    func controllerDidLoad()
}

class TimedUpAndGoInteractor: TimedUpAndGoLogic {

    // MARK: - Private Properties

    private var presenter: TimedUpAndGoPresentationLogic?
    private var selectedOption: SelectableKeys = .secondOption
    private var stopwatchElapsedTime: TimeInterval?
    private var typedElapsedTime: TimeInterval?

    // MARK: - Init

    init(presenter: TimedUpAndGoPresentationLogic) {
        self.presenter = presenter
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        // Not fully implemented
        sendDataToPresenter()
    }

    func didTapActionButton(identifier: String?) {
        if selectedOption == .firstOption {
            guard let typedElapsedTime else { return }
            let results = TimedUpAndGoModels.TestResults(elapsedTime: typedElapsedTime)

            presenter?.route(toRoute: .testResults(test: .timedUpAndGo, results: results))
        } else {
            guard let stopwatchElapsedTime else { return }
            let results = TimedUpAndGoModels.TestResults(elapsedTime: stopwatchElapsedTime)

            presenter?.route(toRoute: .testResults(test: .timedUpAndGo, results: results))
        }
    }

    func didSelect(option: SelectableKeys, value: LocalizedTable) {
        selectedOption = option
        sendDataToPresenter()
    }

    func didStopCounting(elapsedTime: TimeInterval, identifier: String?) {
        stopwatchElapsedTime = elapsedTime
        sendDataToPresenter()
    }

    func didChangeText(text: String, identifier: LocalizedTable?) {
        typedElapsedTime = TimeInterval(text.replacingOccurrences(of: ",", with: "."))
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
}
