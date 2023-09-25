//
//  WalkingSpeedInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation

protocol WalkingSpeedLogic: ActionButtonDelegate, SelectableViewDelegate, StopwatchDelegate, TextFieldDelegate {
    func controllerDidLoad()
    func didSelect(option: WalkingSpeedModels.SelectableStopwatch)
}

class WalkingSpeedInteractor: WalkingSpeedLogic {

    // MARK: - Private Properties

    private var presenter: WalkingSpeedPresentationLogic?
    private var selectedOption: SelectableKeys = .secondOption
    private var selectedStopwatch: WalkingSpeedModels.SelectableStopwatch = .first
    private var firstStopwatchTime: TimeInterval?
    private var secondStopwatchTime: TimeInterval?
    private var thirdStopwatchTime: TimeInterval?
    private var typedFirstTime: TimeInterval?
    private var typedSecondTime: TimeInterval?
    private var typedThirdTime: TimeInterval?

    // MARK: - Init

    init(presenter: WalkingSpeedPresentationLogic) {
        self.presenter = presenter
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        // Not fully implemented
        sendDataToPresenter()
    }

    func didTapActionButton(identifier: String?) {
        if selectedOption == .firstOption {
            guard let typedFirstTime, let typedSecondTime, let typedThirdTime else { return }
            let results = WalkingSpeedModels.TestResults(firstElapsedTime: typedFirstTime,
                                                         secondElapsedTime: typedSecondTime,
                                                         thirdElapsedTime: typedThirdTime)

            presenter?.route(toRoute: .testResults(test: .walkingSpeed, results: results))
        } else {
            guard let firstStopwatchTime, let secondStopwatchTime, let thirdStopwatchTime else { return }
            let results = WalkingSpeedModels.TestResults(firstElapsedTime: firstStopwatchTime,
                                                         secondElapsedTime: secondStopwatchTime,
                                                         thirdElapsedTime: thirdStopwatchTime)

            presenter?.route(toRoute: .testResults(test: .walkingSpeed, results: results))
        }
    }

    func didSelect(option: SelectableKeys, value: LocalizedTable) {
        selectedOption = option
        sendDataToPresenter()
    }

    func didStopCounting(elapsedTime: TimeInterval, identifier: String?) {
        switch identifier {
        case LocalizedTable.firstMeasurement.localized:
            firstStopwatchTime = elapsedTime
        case LocalizedTable.secondMeasurement.localized:
            secondStopwatchTime = elapsedTime
        case LocalizedTable.thirdMeasurement.localized:
            thirdStopwatchTime = elapsedTime
        default:
            return
        }

        sendDataToPresenter()
    }

    func didChangeText(text: String, identifier: LocalizedTable?) {
        guard let identifier else { return }

        switch identifier {
        case .firstMeasurement:
            typedFirstTime = TimeInterval(text)
        case .secondMeasurement:
            typedSecondTime = TimeInterval(text)
        case .thirdMeasurement:
            typedThirdTime = TimeInterval(text)
        default:
            return
        }

        sendDataToPresenter()
    }

    func didSelect(option: WalkingSpeedModels.SelectableStopwatch) {
        selectedStopwatch = option
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> WalkingSpeedModels.ControllerViewModel {
        var isResultsButtonEnabled: Bool = false
        let instructions: [CGAModels.Instruction] = [.init(number: 1, description: LocalizedTable.walkingSpeedFirstInstruction.localized),
                                                     .init(number: 2, description: LocalizedTable.walkingSpeedSecondInstruction.localized),
                                                     .init(number: 3, description: LocalizedTable.walkingSpeedThirdInstruction.localized),
                                                     .init(number: 4, description: LocalizedTable.walkingSpeedFourthInstruction.localized)]

        if let typedFirstTime, let typedSecondTime, let typedThirdTime, selectedOption == .firstOption {
            isResultsButtonEnabled = typedFirstTime > 0 && typedSecondTime > 0 && typedThirdTime > 0 ? true : false
        } else if let firstStopwatchTime, let secondStopwatchTime, let thirdStopwatchTime, selectedOption == .secondOption {
            isResultsButtonEnabled = firstStopwatchTime > 0 && secondStopwatchTime > 0 && thirdStopwatchTime > 0 ? true : false
        }

        return WalkingSpeedModels.ControllerViewModel(instructions: instructions, selectedOption: selectedOption,
                                                      typedFirstTime: typedFirstTime?.description, typedSecondTime: typedSecondTime?.description,
                                                      typedThirdTime: typedThirdTime?.description, firstStopwatchTime: firstStopwatchTime,
                                                      secondStopwatchTime: secondStopwatchTime, thirdStopwatchTime: thirdStopwatchTime,
                                                      selectedStopwatch: selectedStopwatch, isResultsButtonEnabled: isResultsButtonEnabled)
    }
}
