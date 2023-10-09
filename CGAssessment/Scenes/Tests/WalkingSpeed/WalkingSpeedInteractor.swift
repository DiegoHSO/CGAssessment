//
//  WalkingSpeedInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation
import OSLog

protocol WalkingSpeedLogic: ActionButtonDelegate, SelectableViewDelegate, StopwatchDelegate, TextFieldDelegate {
    func controllerDidLoad()
    func didSelect(option: WalkingSpeedModels.SelectableStopwatch)
}

class WalkingSpeedInteractor: WalkingSpeedLogic {

    // MARK: - Private Properties

    private var presenter: WalkingSpeedPresentationLogic?
    private var worker: WalkingSpeedWorker?
    private var cgaId: UUID?
    private var selectedOption: SelectableKeys = .secondOption
    private var selectedStopwatch: WalkingSpeedModels.SelectableStopwatch = .first
    private var firstStopwatchTime: TimeInterval?
    private var secondStopwatchTime: TimeInterval?
    private var thirdStopwatchTime: TimeInterval?
    private var typedFirstTime: TimeInterval?
    private var typedSecondTime: TimeInterval?
    private var typedThirdTime: TimeInterval?

    // MARK: - Init

    init(presenter: WalkingSpeedPresentationLogic, worker: WalkingSpeedWorker, cgaId: UUID?) {
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

        updateDatabase()
        sendDataToPresenter()
    }

    func didChangeText(text: String, identifier: LocalizedTable?) {
        guard let identifier else { return }

        switch identifier {
        case .firstMeasurement:
            typedFirstTime = TimeInterval(text.replacingOccurrences(of: ",", with: "."))
        case .secondMeasurement:
            typedSecondTime = TimeInterval(text.replacingOccurrences(of: ",", with: "."))
        case .thirdMeasurement:
            typedThirdTime = TimeInterval(text.replacingOccurrences(of: ",", with: "."))
        default:
            return
        }

        updateDatabase()
        sendDataToPresenter()
    }

    func didSelect(option: WalkingSpeedModels.SelectableStopwatch) {
        selectedStopwatch = option
        updateDatabase()
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
                                                      typedFirstTime: typedFirstTime?.regionFormatted(fractionDigits: 2),
                                                      typedSecondTime: typedSecondTime?.regionFormatted(fractionDigits: 2),
                                                      typedThirdTime: typedThirdTime?.regionFormatted(fractionDigits: 2),
                                                      firstStopwatchTime: firstStopwatchTime, secondStopwatchTime: secondStopwatchTime,
                                                      thirdStopwatchTime: thirdStopwatchTime, selectedStopwatch: selectedStopwatch,
                                                      isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        if selectedOption == .firstOption {
            guard let typedFirstTime, let typedSecondTime, let typedThirdTime else { return }
            let results = WalkingSpeedModels.TestResults(firstElapsedTime: typedFirstTime,
                                                         secondElapsedTime: typedSecondTime,
                                                         thirdElapsedTime: typedThirdTime)

            presenter?.route(toRoute: .testResults(test: .walkingSpeed, results: results, cgaId: cgaId))
        } else {
            guard let firstStopwatchTime, let secondStopwatchTime, let thirdStopwatchTime else { return }
            let results = WalkingSpeedModels.TestResults(firstElapsedTime: firstStopwatchTime,
                                                         secondElapsedTime: secondStopwatchTime,
                                                         thirdElapsedTime: thirdStopwatchTime)

            presenter?.route(toRoute: .testResults(test: .walkingSpeed, results: results, cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        if let walkingSpeedProgress = try? worker?.getWalkingSpeedProgress() {
            selectedOption = walkingSpeedProgress.hasStopwatch ? .firstOption : .secondOption
            firstStopwatchTime = walkingSpeedProgress.firstMeasuredTime as? Double
            secondStopwatchTime = walkingSpeedProgress.secondMeasuredTime as? Double
            thirdStopwatchTime = walkingSpeedProgress.thirdMeasuredTime as? Double
            typedFirstTime = walkingSpeedProgress.firstTypedTime as? Double
            typedSecondTime = walkingSpeedProgress.secondTypedTime as? Double
            typedThirdTime = walkingSpeedProgress.thirdTypedTime as? Double
            selectedStopwatch = WalkingSpeedModels.SelectableStopwatch(rawValue: walkingSpeedProgress.selectedStopwatch) ?? .first

            if walkingSpeedProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateWalkingSpeedProgress(with: .init(typedFirstTime: typedFirstTime, typedSecondTime: typedSecondTime,
                                                               typedThirdTime: typedThirdTime, firstElapsedTime: firstStopwatchTime,
                                                               secondElapsedTime: secondStopwatchTime, thirdElapsedTime: thirdStopwatchTime,
                                                               selectedOption: selectedOption, selectedStopwatch: selectedStopwatch,
                                                               isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
