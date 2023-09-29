//
//  SarcopeniaAssessmentInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 28/09/23.
//

import Foundation

protocol SarcopeniaAssessmentLogic: ActionButtonDelegate {
    func controllerDidLoad()
    func didSelect(test: SingleDomainModels.Test)
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
        presenter?.route(toRoute: .testResults(test: .sarcopeniaAssessment, results: .init(gripStrengthResults: .init(firstMeasurement: 10,
                                                                                                                      secondMeasurement: 20,
                                                                                                                      thirdMeasurement: 25,
                                                                                                                      gender: .male))))
    }

    func didSelect(test: SingleDomainModels.Test) {
        switch test {
        case .gripStrength:
            presenter?.route(toRoute: .gripStrength)
        case .calfCircumference:
            presenter?.route(toRoute: .calfCircumference)
        case .timedUpAndGo:
            presenter?.route(toRoute: .timedUpAndGo)
        case .walkingSpeed:
            presenter?.route(toRoute: .walkingSpeed)
        default:
            break
        }
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> SarcopeniaAssessmentModels.ControllerViewModel {
        return SarcopeniaAssessmentModels.ControllerViewModel(testsCompletionStatus: [.gripStrength: .done, .calfCircumference: .done,
                                                                                      .timedUpAndGo: .notStarted, .walkingSpeed: .done],
                                                              testsResults: [.gripStrength: .bad, .calfCircumference: .bad], isResultsButtonEnabled: false)
    }
}
