//
//  SarcopeniaScreeningInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import Foundation
import OSLog

protocol SarcopeniaScreeningLogic: ActionButtonDelegate, SelectableViewDelegate {
    func controllerDidLoad()
}

class SarcopeniaScreeningInteractor: SarcopeniaScreeningLogic {

    // MARK: - Private Properties

    private var presenter: SarcopeniaScreeningPresentationLogic?
    private var worker: SarcopeniaScreeningWorker?
    private var cgaId: UUID?
    private var gender: Gender?
    private var rawQuestions: SarcopeniaScreeningModels.RawQuestions = [
        .sarcopeniaAssessmentFirstQuestion: .none, .sarcopeniaAssessmentSecondQuestion: .none,
        .sarcopeniaAssessmentThirdQuestion: .none, .sarcopeniaAssessmentFourthQuestion: .none,
        .sarcopeniaAssessmentFifthQuestion: .none, .sarcopeniaAssessmentSixthQuestion: .none
    ]

    // MARK: - Init

    init(presenter: SarcopeniaScreeningPresentationLogic, worker: SarcopeniaScreeningWorker, cgaId: UUID?) {
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
        rawQuestions[value] = option

        updateDatabase()
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> SarcopeniaScreeningModels.ControllerViewModel {
        let questions: SarcopeniaScreeningModels.Questions = [.firstQuestion: .init(question: .sarcopeniaAssessmentFirstQuestion, selectedOption: rawQuestions[.sarcopeniaAssessmentFirstQuestion] ?? .none,
                                                                                    options: [.firstOption: .noneGenderFlexion,
                                                                                              .secondOption: .some,
                                                                                              .thirdOption: .muchOrUnable]),
                                                              .secondQuestion: .init(question: .sarcopeniaAssessmentSecondQuestion, selectedOption: rawQuestions[.sarcopeniaAssessmentSecondQuestion] ?? .none,
                                                                                     options: [.firstOption: .noneGenderFlexion,
                                                                                               .secondOption: .some,
                                                                                               .thirdOption: .usesSupport]),
                                                              .thirdQuestion: .init(question: .sarcopeniaAssessmentThirdQuestion, selectedOption: rawQuestions[.sarcopeniaAssessmentThirdQuestion] ?? .none,
                                                                                    options: [.firstOption: .noneGenderFlexion,
                                                                                              .secondOption: .some,
                                                                                              .thirdOption: .unableWithoutHelp]),
                                                              .fourthQuestion: .init(question: .sarcopeniaAssessmentFourthQuestion, selectedOption: rawQuestions[.sarcopeniaAssessmentFourthQuestion] ?? .none,
                                                                                     options: [.firstOption: .noneGenderFlexion,
                                                                                               .secondOption: .some,
                                                                                               .thirdOption: .muchOrUnable]),
                                                              .fifthQuestion: .init(question: .sarcopeniaAssessmentFifthQuestion, selectedOption: rawQuestions[.sarcopeniaAssessmentFifthQuestion] ?? .none,
                                                                                    options: [.firstOption: .noneGenderFlexion,
                                                                                              .secondOption: .oneToThreeFalls,
                                                                                              .thirdOption: .fourOrMoreFalls]),
                                                              .sixthQuestion: .init(question: .sarcopeniaAssessmentSixthQuestion, selectedOption: rawQuestions[.sarcopeniaAssessmentSixthQuestion] ?? .none,
                                                                                    options: [.firstOption: gender == .female ? .circumferenceBiggerThanLimitWomen :
                                                                                                .circumferenceBiggerThanLimitMen,
                                                                                              .secondOption: gender == .female ? .circumferenceLowerThanLimitWomen :
                                                                                                .circumferenceLowerThanLimitMen])
        ]

        let selectedOptions = rawQuestions.values.map { $0 as SelectableKeys }

        let isResultsButtonEnabled: Bool = selectedOptions.allSatisfy({ $0 != .none })

        return SarcopeniaScreeningModels.ControllerViewModel(questions: questions, isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        let selectedOptions = rawQuestions.values.map { $0 as SelectableKeys }

        if selectedOptions.allSatisfy({$0 != .none}) {
            presenter?.route(toRoute: .testResults(test: .sarcopeniaScreening, results: .init(questions: rawQuestions), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        gender = try? worker?.getPatientGender()

        if let sarcopeniaScreeningProgress = try? worker?.getSarcopeniaScreeningProgress() {
            guard let questionOptions = sarcopeniaScreeningProgress.selectableOptions?.allObjects as? [SelectableOption] else {
                return
            }

            questionOptions.forEach { option in
                guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                rawQuestions[identifier] = selectedOption
            }

            if sarcopeniaScreeningProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateSarcopeniaScreeningProgress(with: .init(questions: rawQuestions, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
