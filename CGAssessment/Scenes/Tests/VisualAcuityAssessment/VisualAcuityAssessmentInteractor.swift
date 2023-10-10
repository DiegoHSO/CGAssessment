//
//  VisualAcuityAssessmentInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 10/10/23.
//

import Foundation
import OSLog

protocol VisualAcuityAssessmentLogic: ActionButtonDelegate, SelectableViewDelegate, GroupedButtonDelegate {
    func controllerDidLoad()
}

class VisualAcuityAssessmentInteractor: VisualAcuityAssessmentLogic {

    // MARK: - Private Properties

    private var presenter: VisualAcuityAssessmentPresentationLogic?
    private var worker: VisualAcuityAssessmentWorker?
    private var cgaId: UUID?
    private var selectedOption: SelectableKeys = .none

    // MARK: - Init

    init(presenter: VisualAcuityAssessmentPresentationLogic, worker: VisualAcuityAssessmentWorker, cgaId: UUID?) {
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

    func didSelect(buttonIdentifier: LocalizedTable) {
        switch buttonIdentifier {
        case .print:
            let fileURL = Bundle.main.url(forResource: "snellen_chart", withExtension: "pdf")
            presenter?.route(toRoute: .printing(fileURL: fileURL))
        case .savePDF:
            let documentPath = Bundle.main.url(forResource: "snellen_chart", withExtension: "pdf")
            let fileManager = FileManager.default

            if fileManager.fileExists(atPath: documentPath?.relativePath ?? "") {
                presenter?.route(toRoute: .pdfSaving(pdfData: documentPath))
            }
        default:
            break
        }
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> VisualAcuityAssessmentModels.ControllerViewModel {
        let instructions: [CGAModels.Instruction] = [.init(number: 1, description: LocalizedTable.visualAcuityAssessmentFirstInstruction.localized),
                                                     .init(number: 2, description: LocalizedTable.visualAcuityAssessmentSecondInstruction.localized),
                                                     .init(number: 3, description: LocalizedTable.visualAcuityAssessmentThirdInstruction.localized),
                                                     .init(number: 4, description: LocalizedTable.visualAcuityAssessmentFourthInstruction.localized)]
        let question: VisualAcuityAssessmentModels.QuestionViewModel = .init(question: .visualAcuityAssessmentQuestion, selectedOption: selectedOption,
                                                                             options: [.firstOption: .twentySlashTwoHundred, .secondOption: .twentySlashOneHundred,
                                                                                       .thirdOption: .twentySlashSeventy, .fourthOption: .twentySlashSixty,
                                                                                       .fifthOption: .twentySlashFifty, .sixthOption: .twentySlashFourty,
                                                                                       .seventhOption: .twentySlashThirty, .eighthOption: .twentySlashTwentyFive,
                                                                                       .ninthOption: .twentySlashTwenty, .tenthOption: .twentySlashFifteen,
                                                                                       .eleventhOption: .twentySlashThirteen, .twelfthOption: .twentySlashTen,
                                                                                       .thirteenthOption: .twentySlashEight, .fourteenthOption: .twentySlashSix,
                                                                                       .fifteenthOption: .twentySlashFive, .sixteenthOption: .twentySlashFour])

        let groupedButtons: [CGAModels.GroupedButtonViewModel] = [.init(title: .print, symbolName: "printer.fill", delegate: self),
                                                                  .init(title: .savePDF, symbolName: "arrow.down.doc.fill", delegate: self)]

        let isResultsButtonEnabled = selectedOption != .none ? true : false

        return .init(instructions: instructions, buttons: groupedButtons, question: question,
                     selectedOption: selectedOption, isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        let results = VisualAcuityAssessmentModels.TestResults(selectedOption: selectedOption)

        presenter?.route(toRoute: .testResults(test: .visualAcuityAssessment, results: results, cgaId: cgaId))
    }

    private func computeViewModelData() {
        if let visualAcuityAssessmentProgress = try? worker?.getVisualAcuityAssessmentProgress() {
            selectedOption = SelectableKeys(rawValue: visualAcuityAssessmentProgress.selectedOption) ?? .none

            if visualAcuityAssessmentProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateVisualAcuityAssessmentProgress(with: .init(selectedOption: selectedOption, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
