//
//  HearingLossAsssessmentInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation
import OSLog

protocol HearingLossAssessmentLogic: ActionButtonDelegate {
    func controllerDidLoad()
}

class HearingLossAssessmentInteractor: HearingLossAssessmentLogic {

    // MARK: - Private Properties

    private var presenter: HearingLossAssessmentPresentationLogic?
    private var worker: HearingLossAssessmentWorker?
    private var cgaId: UUID?
    private var selectedOption: SelectableKeys = .none

    // MARK: - Init

    init(presenter: HearingLossAssessmentPresentationLogic, worker: HearingLossAssessmentWorker, cgaId: UUID?) {
        self.presenter = presenter
        self.worker = worker
        self.cgaId = cgaId
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        sendDataToPresenter()
    }

    func didTapActionButton(identifier: String?) {
        handleNavigation(updatesDatabase: true)
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> HearingLossAssessmentModels.ControllerViewModel {
        let instructions: [CGAModels.Instruction] = [.init(number: 1, description: LocalizedTable.hearingLossAssessmentFirstInstruction.localized),
                                                     .init(number: 2, description: LocalizedTable.hearingLossAssessmentSecondInstruction.localized),
                                                     .init(number: 3, description: LocalizedTable.hearingLossAssessmentThirdInstruction.localized),
                                                     .init(number: 4, description: LocalizedTable.hearingLossAssessmentFourthInstruction.localized),
                                                     .init(number: 5, description: LocalizedTable.hearingLossAssessmentFifthInstruction.localized),
                                                     .init(number: 6, description: LocalizedTable.hearingLossAssessmentSixthInstruction.localized)]

        return .init(instructions: instructions, isResultsButtonEnabled: true)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        presenter?.route(toRoute: .katzScale(cgaId: cgaId))
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateHearingLossAssessmentProgress(with: .init(isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
