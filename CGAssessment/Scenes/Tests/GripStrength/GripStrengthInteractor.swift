//
//  GripStrengthInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import Foundation
import OSLog

protocol GripStrengthLogic: ActionButtonDelegate, TextFieldDelegate {
    func controllerDidLoad()
}

class GripStrengthInteractor: GripStrengthLogic {

    // MARK: - Private Properties

    private var presenter: GripStrengthPresentationLogic?
    private var worker: GripStrengthWorker?
    private var cgaId: UUID?
    private var typedFirstMeasurement: Double?
    private var typedSecondMeasurement: Double?
    private var typedThirdMeasurement: Double?

    // MARK: - Init

    init(presenter: GripStrengthPresentationLogic, worker: GripStrengthWorker, cgaId: UUID?) {
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

    func didChangeText(text: String, identifier: LocalizedTable?) {
        guard let identifier else { return }

        switch identifier {
        case .firstMeasurement:
            typedFirstMeasurement = TimeInterval(text.replacingOccurrences(of: ",", with: "."))
        case .secondMeasurement:
            typedSecondMeasurement = TimeInterval(text.replacingOccurrences(of: ",", with: "."))
        case .thirdMeasurement:
            typedThirdMeasurement = TimeInterval(text.replacingOccurrences(of: ",", with: "."))
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

    private func createViewModel() -> GripStrengthModels.ControllerViewModel {
        var isResultsButtonEnabled: Bool = false
        let instructions: [CGAModels.Instruction] = [.init(number: 1, description: LocalizedTable.gripStrengthFirstInstruction.localized),
                                                     .init(number: 2, description: LocalizedTable.gripStrengthSecondInstruction.localized),
                                                     .init(number: 3, description: LocalizedTable.gripStrengthThirdInstruction.localized),
                                                     .init(number: 4, description: LocalizedTable.gripStrengthFourthInstruction.localized),
                                                     .init(number: 5, description: LocalizedTable.gripStrengthFifthInstruction.localized)]

        if let typedFirstMeasurement, let typedSecondMeasurement, let typedThirdMeasurement,
           typedFirstMeasurement > 0, typedSecondMeasurement > 0, typedThirdMeasurement > 0 {
            isResultsButtonEnabled = true
        } else {
            isResultsButtonEnabled = false
        }

        return GripStrengthModels.ControllerViewModel(instructions: instructions,
                                                      typedFirstMeasurement: typedFirstMeasurement?.regionFormatted(fractionDigits: 2),
                                                      typedSecondMeasurement: typedSecondMeasurement?.regionFormatted(fractionDigits: 2),
                                                      typedThirdMeasurement: typedThirdMeasurement?.regionFormatted(fractionDigits: 2),
                                                      imageName: "gripStrength", isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        guard let typedFirstMeasurement, let typedSecondMeasurement, let typedThirdMeasurement,
              let gender = try? worker?.getPatientGender(), typedFirstMeasurement > 0,
              typedSecondMeasurement > 0, typedThirdMeasurement > 0 else { return }

        presenter?.route(toRoute: .testResults(test: .gripStrength, results: .init(firstMeasurement: typedFirstMeasurement,
                                                                                   secondMeasurement: typedSecondMeasurement,
                                                                                   thirdMeasurement: typedThirdMeasurement,
                                                                                   gender: gender), cgaId: cgaId))
    }

    private func computeViewModelData() {
        if let gripStrengthProgress = try? worker?.getGripStrengthProgress() {
            typedFirstMeasurement = gripStrengthProgress.firstMeasurement as? Double
            typedSecondMeasurement = gripStrengthProgress.secondMeasurement as? Double
            typedThirdMeasurement = gripStrengthProgress.thirdMeasurement as? Double

            if gripStrengthProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateGripStrengthProgress(with: .init(firstMeasurement: typedFirstMeasurement, secondMeasurement: typedSecondMeasurement,
                                                               thirdMeasurement: typedThirdMeasurement, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
