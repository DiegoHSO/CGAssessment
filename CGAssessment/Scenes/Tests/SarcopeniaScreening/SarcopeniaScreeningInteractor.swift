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
    private var firstQuestionOption: SelectableKeys = .none
    private var secondQuestionOption: SelectableKeys = .none
    private var thirdQuestionOption: SelectableKeys = .none
    private var fourthQuestionOption: SelectableKeys = .none
    private var fifthQuestionOption: SelectableKeys = .none
    private var sixthQuestionOption: SelectableKeys = .none
    private var gender: Gender?

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
        switch value {
        case .sarcopeniaAssessmentFirstQuestion:
            firstQuestionOption = option
        case .sarcopeniaAssessmentSecondQuestion:
            secondQuestionOption = option
        case .sarcopeniaAssessmentThirdQuestion:
            thirdQuestionOption = option
        case .sarcopeniaAssessmentFourthQuestion:
            fourthQuestionOption = option
        case .sarcopeniaAssessmentFifthQuestion:
            fifthQuestionOption = option
        case .sarcopeniaAssessmentSixthQuestion:
            sixthQuestionOption = option
        default:
            break
        }

        updateDatabase()
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> SarcopeniaScreeningModels.ControllerViewModel {
        let questions: SarcopeniaScreeningModels.Questions = [.firstQuestion: .init(question: .sarcopeniaAssessmentFirstQuestion,
                                                                                    options: [.firstOption: .noneGenderFlexion,
                                                                                              .secondOption: .some,
                                                                                              .thirdOption: .muchOrUnable]),
                                                              .secondQuestion: .init(question: .sarcopeniaAssessmentSecondQuestion,
                                                                                     options: [.firstOption: .noneGenderFlexion,
                                                                                               .secondOption: .some,
                                                                                               .thirdOption: .usesSupport]),
                                                              .thirdQuestion: .init(question: .sarcopeniaAssessmentThirdQuestion,
                                                                                    options: [.firstOption: .noneGenderFlexion,
                                                                                              .secondOption: .some,
                                                                                              .thirdOption: .unableWithoutHelp]),
                                                              .fourthQuestion: .init(question: .sarcopeniaAssessmentFourthQuestion,
                                                                                     options: [.firstOption: .noneGenderFlexion,
                                                                                               .secondOption: .some,
                                                                                               .thirdOption: .muchOrUnable]),
                                                              .fifthQuestion: .init(question: .sarcopeniaAssessmentFifthQuestion,
                                                                                    options: [.firstOption: .noneGenderFlexion,
                                                                                              .secondOption: .oneToThreeFalls,
                                                                                              .thirdOption: .fourOrMoreFalls]),
                                                              .sixthQuestion: .init(question: .sarcopeniaAssessmentSixthQuestion,
                                                                                    options: [.firstOption: gender == .female ? .circumferenceBiggerThanLimitWomen :
                                                                                                .circumferenceBiggerThanLimitMen,
                                                                                              .secondOption: gender == .female ? .circumferenceLowerThanLimitWomen :
                                                                                                .circumferenceLowerThanLimitMen])
        ]

        let selectedOptions = [firstQuestionOption, secondQuestionOption, thirdQuestionOption,
                               fourthQuestionOption, fifthQuestionOption, sixthQuestionOption]

        let isResultsButtonEnabled: Bool = selectedOptions.allSatisfy({$0 != .none})

        return SarcopeniaScreeningModels.ControllerViewModel(questions: questions, firstQuestionOption: firstQuestionOption,
                                                             secondQuestionOption: secondQuestionOption, thirdQuestionOption: thirdQuestionOption,
                                                             fourthQuestionOption: fourthQuestionOption, fifthQuestionOption: fifthQuestionOption,
                                                             sixthQuestionOption: sixthQuestionOption,
                                                             isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        let selectedOptions = [firstQuestionOption, secondQuestionOption, thirdQuestionOption,
                               fourthQuestionOption, fifthQuestionOption, sixthQuestionOption]

        if let gender, selectedOptions.allSatisfy({$0 != .none}) {
            presenter?.route(toRoute: .testResults(test: .sarcopeniaAssessment, results: .init(firstQuestionOption: firstQuestionOption,
                                                                                               secondQuestionOption: secondQuestionOption,
                                                                                               thirdQuestionOption: thirdQuestionOption,
                                                                                               fourthQuestionOption: fourthQuestionOption,
                                                                                               fifthQuestionOption: fifthQuestionOption,
                                                                                               sixthQuestionOption: sixthQuestionOption,
                                                                                               gender: gender), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        gender = try? worker?.getPatientGender()

        if let sarcopeniaScreeningProgress = try? worker?.getSarcopeniaScreeningProgress() {
            guard let firstQuestionOption = SelectableKeys(rawValue: sarcopeniaScreeningProgress.firstQuestionOption),
                  let secondQuestionOption = SelectableKeys(rawValue: sarcopeniaScreeningProgress.secondQuestionOption),
                  let thirdQuestionOption = SelectableKeys(rawValue: sarcopeniaScreeningProgress.thirdQuestionOption),
                  let fourthQuestionOption = SelectableKeys(rawValue: sarcopeniaScreeningProgress.fourthQuestionOption),
                  let fifthQuestionOption = SelectableKeys(rawValue: sarcopeniaScreeningProgress.fifthQuestionOption),
                  let sixthQuestionOption = SelectableKeys(rawValue: sarcopeniaScreeningProgress.sixthQuestionOption) else {
                return
            }

            self.firstQuestionOption = firstQuestionOption
            self.secondQuestionOption = secondQuestionOption
            self.thirdQuestionOption = thirdQuestionOption
            self.fourthQuestionOption = fourthQuestionOption
            self.fifthQuestionOption = fifthQuestionOption
            self.sixthQuestionOption = sixthQuestionOption

            if sarcopeniaScreeningProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateSarcopeniaScreeningProgress(with: .init(firstQuestionOption: firstQuestionOption, secondQuestionOption: secondQuestionOption,
                                                                      thirdQuestionOption: thirdQuestionOption, fourthQuestionOption: fourthQuestionOption,
                                                                      fifthQuestionOption: fifthQuestionOption, sixthQuestionOption: sixthQuestionOption,
                                                                      isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
