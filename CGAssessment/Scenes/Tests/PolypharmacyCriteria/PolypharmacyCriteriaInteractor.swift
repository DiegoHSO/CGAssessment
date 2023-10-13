//
//  PolypharmacyCriteriaInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation
import OSLog

protocol PolypharmacyCriteriaLogic: ActionButtonDelegate, SheetableDelegate, PickerViewDelegate {
    func controllerDidLoad()
}

class PolypharmacyCriteriaInteractor: PolypharmacyCriteriaLogic {

    // MARK: - Private Properties

    private var presenter: PolypharmacyCriteriaPresentationLogic?
    private var worker: PolypharmacyCriteriaWorker?
    private var cgaId: UUID?
    private var numberOfMedicines: Int16?
    private let medicinesArray: [String] = Array(0...100).map({ "\($0) \($0 == 1 ? LocalizedTable.medicineSingular.localized : LocalizedTable.medicinePlural.localized)" })

    // MARK: - Init

    init(presenter: PolypharmacyCriteriaPresentationLogic, worker: PolypharmacyCriteriaWorker, cgaId: UUID?) {
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

    func didTapPicker(identifier: LocalizedTable?) {
        let selectedRow: Int
        selectedRow = medicinesArray.firstIndex(of: "\(numberOfMedicines ?? 0) \(numberOfMedicines == 1 ? LocalizedTable.medicineSingular.localized : LocalizedTable.medicinePlural.localized)") ?? 0

        presenter?.route(toRoute: .openBottomSheet(viewModel: .init(pickerContent: medicinesArray, identifier: identifier, delegate: self, selectedRow: selectedRow)))
    }

    func didSelectPickerRow(identifier: LocalizedTable?, row: Int) {
        var selectedNumber = medicinesArray[safe: row]?.replacingOccurrences(of: " \(LocalizedTable.medicinePlural.localized)", with: "")
        if Int16(selectedNumber ?? "") == nil {
            selectedNumber = selectedNumber?.replacingOccurrences(of: " \(LocalizedTable.medicineSingular.localized)", with: "")
        }

        self.numberOfMedicines = Int16(selectedNumber ?? "")

        updateDatabase()
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> PolypharmacyCriteriaModels.ControllerViewModel {
        let instructions: [CGAModels.Instruction] = [.init(number: 1, description: LocalizedTable.polypharmacyCriteriaFirstInstruction.localized),
                                                     .init(number: 2, description: LocalizedTable.polypharmacyCriteriaSecondInstruction.localized)]

        let picker: CGAModels.SheetableViewModel = .init(title: nil, pickerName: LocalizedTable.numberOfMedicines,
                                                         pickerValue: "\(numberOfMedicines ?? 0) \(numberOfMedicines == 1 ? LocalizedTable.medicineSingular.localized : LocalizedTable.medicinePlural.localized)", delegate: self)

        let isResultsButtonEnabled = numberOfMedicines != nil

        return .init(instructions: instructions, picker: picker, pickerContent: medicinesArray, isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        let isAllDone = numberOfMedicines != nil

        if isAllDone {
            guard let numberOfMedicines else { return }
            presenter?.route(toRoute: .testResults(test: .polypharmacyCriteria, results: .init(numberOfMedicines: numberOfMedicines), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        if let polypharmacyCriteriaProgress = try? worker?.getPolypharmacyCriteriaProgress() {
            numberOfMedicines = polypharmacyCriteriaProgress.numberOfMedicines

            if polypharmacyCriteriaProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updatePolypharmacyCriteriaProgress(with: .init(numberOfMedicines: numberOfMedicines, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
