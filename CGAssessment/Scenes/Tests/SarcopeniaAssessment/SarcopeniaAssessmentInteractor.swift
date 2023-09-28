//
//  SarcopeniaAssessmentInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 27/09/23.
//

import Foundation

protocol SarcopeniaAssessmentLogic: ActionButtonDelegate, SelectableViewDelegate {
    func controllerDidLoad()
}

class SarcopeniaAssessmentInteractor: SarcopeniaAssessmentLogic {

    // MARK: - Private Properties

    private var presenter: SarcopeniaAssessmentPresentationLogic?
    private var firstQuestionOption: SelectableKeys = .none
    private var secondQuestionOption: SelectableKeys = .none
    private var thirdQuestionOption: SelectableKeys = .none
    private var fourthQuestionOption: SelectableKeys = .none
    private var fifthQuestionOption: SelectableKeys = .none
    private var sixthQuestionOption: SelectableKeys = .none

    // MARK: - Init

    init(presenter: SarcopeniaAssessmentPresentationLogic) {
        self.presenter = presenter
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        // Not fully implemented
        sendDataToPresenter()
    }

    func didTapActionButton(identifier: String?) {
        let selectedOptions = [firstQuestionOption, secondQuestionOption, thirdQuestionOption,
                               fourthQuestionOption, fifthQuestionOption, sixthQuestionOption]

        if selectedOptions.allSatisfy({$0 != .none}) {
            presenter?.route(toRoute: .testResults(test: .sarcopeniaAssessment, results: .init(firstQuestionOption: firstQuestionOption,
                                                                                               secondQuestionOption: secondQuestionOption,
                                                                                               thirdQuestionOption: thirdQuestionOption,
                                                                                               fourthQuestionOption: fourthQuestionOption,
                                                                                               fifthQuestionOption: fifthQuestionOption,
                                                                                               sixthQuestionOption: sixthQuestionOption)))
        }
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

        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> SarcopeniaAssessmentModels.ControllerViewModel {
        let questions: SarcopeniaAssessmentModels.Questions = [.firstQuestion: .init(question: .sarcopeniaAssessmentFirstQuestion,
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
                                                                                     options: [.firstOption: .circumferenceBiggerThanLimit,
                                                                                               .secondOption: .circumferenceLowerThanLimit])
        ]

        let selectedOptions = [firstQuestionOption, secondQuestionOption, thirdQuestionOption,
                               fourthQuestionOption, fifthQuestionOption, sixthQuestionOption]

        let isResultsButtonEnabled: Bool = selectedOptions.allSatisfy({$0 != .none})

        return SarcopeniaAssessmentModels.ControllerViewModel(questions: questions, firstQuestionOption: firstQuestionOption,
                                                              secondQuestionOption: secondQuestionOption, thirdQuestionOption: thirdQuestionOption,
                                                              fourthQuestionOption: fourthQuestionOption, fifthQuestionOption: fifthQuestionOption,
                                                              sixthQuestionOption: sixthQuestionOption,
                                                              isResultsButtonEnabled: isResultsButtonEnabled)
    }
}
