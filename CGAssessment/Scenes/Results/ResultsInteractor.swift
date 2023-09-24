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

    // MARK: - Init

    init(presenter: ResultsPresentationLogic, worker: ResultsWorker, test: SingleDomainModels.Test, results: Any) {
        self.presenter = presenter
        self.worker = worker
        self.test = test
        self.results = results
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        sendDataToPresenter()
    }

    func didTapActionButton(identifier: String?) {
        switch identifier {
        case LocalizedTable.nextTest.localized:
            presenter?.route(toRoute: .nextTest(test: test.next()))
        case LocalizedTable.returnKey.localized:
            presenter?.route(toRoute: .routeBack(domain: test.domain))
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
            return .init(testName: "", results: [], resultType: .excellent)
        }

        return ResultsModels.ViewModel(testName: test.title, results: resultsTuple.0, resultType: resultsTuple.1)
    }
}
