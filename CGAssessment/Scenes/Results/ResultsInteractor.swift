//
//  ResultsInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation

protocol ResultsLogic: ActionButtonDelegate {
    func controllerDidLoad()
}

class ResultsInteractor: ResultsLogic {

    // MARK: - Private Properties

    private var presenter: ResultsPresentationLogic?
    private var worker: ResultsWorker?
    private var test: SingleDomainModels.Test
    private var results: Any
    private var isInSpecialFlow: Bool

    // MARK: - Init

    init(presenter: ResultsPresentationLogic, worker: ResultsWorker, test: SingleDomainModels.Test, results: Any, isInSpecialFlow: Bool) {
        self.presenter = presenter
        self.worker = worker
        self.test = test
        self.results = results
        self.isInSpecialFlow = isInSpecialFlow
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        sendDataToPresenter()
    }

    func didTapActionButton(identifier: String?) {
        switch identifier {
        case LocalizedTable.nextTest.localized:
            presenter?.route(toRoute: .nextTest(test: test == .sarcopeniaAssessment ? .miniMentalStateExamination : test.next()))
        case LocalizedTable.returnKey.localized:
            presenter?.route(toRoute: .routeBack(domain: test.domain))
        case LocalizedTable.secondStep.localized:
            presenter?.route(toRoute: .sarcopeniaAssessment)
        default:
            break
        }
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> ResultsModels.ViewModel {
        guard let resultsTuple: ([ResultsModels.Result], ResultsModels.ResultType) = worker?.getResults(for: test, results: results) else {
            return .init(testName: "", results: [], resultType: .excellent, isInSpecialFlow: isInSpecialFlow)
        }

        if results is SarcopeniaScreeningModels.TestResults {
            if resultsTuple.1 == .excellent {
                try? worker?.updateSarcopeniaAssessmentProgress(with: .init(isDone: true))
            } else {
                try? worker?.updateSarcopeniaAssessmentProgress(with: .init(isDone: false))
            }

            return ResultsModels.ViewModel(testName: LocalizedTable.sarcopeniaScreening.localized,
                                           results: resultsTuple.0, resultType: resultsTuple.1, isInSpecialFlow: isInSpecialFlow)
        }

        return ResultsModels.ViewModel(testName: test.title, results: resultsTuple.0, resultType: resultsTuple.1, isInSpecialFlow: isInSpecialFlow)
    }
}
