//
//  SuspectedAbuseInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import Foundation
import OSLog

protocol SuspectedAbuseLogic: ActionButtonDelegate, SelectableViewDelegate, TextViewDelegate {
    func controllerDidLoad()
}

class SuspectedAbuseInteractor: SuspectedAbuseLogic {

    // MARK: - Private Properties

    private var presenter: SuspectedAbusePresentationLogic?
    private var worker: SuspectedAbuseWorker?
    private var cgaId: UUID?
    private var typedText: String?
    private var selectedOption: SelectableKeys = .none

    // MARK: - Init

    init(presenter: SuspectedAbusePresentationLogic, worker: SuspectedAbuseWorker, cgaId: UUID?) {
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
        self.typedText = text

        updateDatabase()
        sendDataToPresenter()
    }

    func didSelect(option: SelectableKeys, value: LocalizedTable) {
        selectedOption = option

        updateDatabase()
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> SuspectedAbuseModels.ControllerViewModel {
        var isResultsButtonEnabled: Bool = false

        if selectedOption == .firstOption, let typedText, !typedText.isEmpty {
            isResultsButtonEnabled = true
        } else if selectedOption == .secondOption {
            isResultsButtonEnabled = true
        } else {
            isResultsButtonEnabled = false
        }

        let textViewModel: CGAModels.TextViewViewModel = .init(title: LocalizedTable.suspectedAbuseTextViewTitle.localized, text: typedText,
                                                               placeholder: LocalizedTable.suspectedAbuseTextViewPlaceholder.localized,
                                                               delegate: self, identifier: .suspectedAbuseTextViewTitle)

        return SuspectedAbuseModels.ControllerViewModel(selectedOption: selectedOption, textViewModel: textViewModel,
                                                        isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        presenter?.route(toRoute: .cardiovascularRisk(cgaId: cgaId))
    }

    private func computeViewModelData() {
        if let suspectedAbuseProgress = try? worker?.getSuspectedAbuseProgress() {
            typedText = suspectedAbuseProgress.typedText
            selectedOption = SelectableKeys(rawValue: suspectedAbuseProgress.selectedOption) ?? .none

            if suspectedAbuseProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateSuspectedAbuseProgress(with: .init(selectedOption: selectedOption, typedText: typedText, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
