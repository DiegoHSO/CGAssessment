//
//  CalfCircumferenceInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import Foundation
import OSLog

protocol CalfCircumferenceLogic: ActionButtonDelegate, TextFieldDelegate {
    func controllerDidLoad()
}

class CalfCircumferenceInteractor: CalfCircumferenceLogic {

    // MARK: - Private Properties

    private var presenter: CalfCircumferencePresentationLogic?
    private var worker: CalfCircumferenceWorker?
    private var cgaId: UUID?
    private var typedCircumference: Double?

    // MARK: - Init

    init(presenter: CalfCircumferencePresentationLogic, worker: CalfCircumferenceWorker, cgaId: UUID?) {
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
        typedCircumference = Double(text.replacingOccurrences(of: ",", with: "."))
        updateDatabase()
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> CalfCircumferenceModels.ControllerViewModel {
        var isResultsButtonEnabled: Bool = false
        let instructions: [CGAModels.Instruction] = [.init(number: 1, description: LocalizedTable.calfCircumferenceInstruction.localized)]

        if let typedCircumference, typedCircumference > 0 {
            isResultsButtonEnabled = true
        } else {
            isResultsButtonEnabled = false
        }

        return CalfCircumferenceModels.ControllerViewModel(instructions: instructions,
                                                           typedCircumference: typedCircumference?.regionFormatted(fractionDigits: 2),
                                                           imageName: "calfCircumference",
                                                           isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        guard let typedCircumference else { return }
        presenter?.route(toRoute: .testResults(test: .calfCircumference, results: .init(circumference: typedCircumference), cgaId: cgaId))
    }

    private func computeViewModelData() {
        if let calfCircumferenceProgress = try? worker?.getCalfCircumferenceProgress() {
            typedCircumference = calfCircumferenceProgress.measuredCircumference as? Double

            if calfCircumferenceProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateCalfCircumferenceProgress(with: .init(circumference: typedCircumference, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
