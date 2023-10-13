//
//  ZaritScaleInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 12/10/23.
//

import Foundation
import OSLog

protocol ZaritScaleLogic: ActionButtonDelegate, SelectableViewDelegate {
    func controllerDidLoad()
}

class ZaritScaleInteractor: ZaritScaleLogic {

    // MARK: - Private Properties

    private var presenter: ZaritScalePresentationLogic?
    private var worker: ZaritScaleWorker?
    private var cgaId: UUID?
    private var rawQuestions: ZaritScaleModels.RawQuestions = [
        .zaritScaleQuestionOne: .none, .zaritScaleQuestionTwo: .none, .zaritScaleQuestionThree: .none,
        .zaritScaleQuestionFour: .none, .zaritScaleQuestionFive: .none, .zaritScaleQuestionSix: .none,
        .zaritScaleQuestionSeven: .none
    ]
    private var questionsOrder: ZaritScaleModels.QuestionsOrder = [
        .zaritScaleQuestionOne: 1, .zaritScaleQuestionTwo: 2, .zaritScaleQuestionThree: 3,
        .zaritScaleQuestionFour: 4, .zaritScaleQuestionFive: 5, .zaritScaleQuestionSix: 6,
        .zaritScaleQuestionSeven: 7
    ]

    // MARK: - Init

    init(presenter: ZaritScalePresentationLogic, worker: ZaritScaleWorker, cgaId: UUID?) {
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

    private func createViewModel() -> ZaritScaleModels.ControllerViewModel {
        let questions: [ZaritScaleModels.QuestionViewModel] = rawQuestions.map {
            return .init(question: $0.key, selectedOption: $0.value, options: [.firstOption: .never, .secondOption: .hardlyEver, .thirdOption: .sometimes,
                                                                               .fourthOption: .frequently, .fifthOption: .nearlyAlways])
        }.sorted(by: { questionsOrder[$0.question ?? .none] ?? 0 < questionsOrder[$1.question ?? .none] ?? 0 })

        let selectedOptions = rawQuestions.values.map { $0 as SelectableKeys }
        let isResultsButtonEnabled: Bool = selectedOptions.allSatisfy({$0 != .none})

        return .init(questions: questions, isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        let selectedOptions = rawQuestions.values.map { $0 as SelectableKeys }
        let isAllDone: Bool = selectedOptions.allSatisfy({$0 != .none})

        if isAllDone {
            presenter?.route(toRoute: .testResults(test: .zaritScale, results: .init(questions: rawQuestions), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        if let zaritScaleProgress = try? worker?.getZaritScaleProgress() {
            guard let questionOptions = zaritScaleProgress.selectableOptions?.allObjects as? [SelectableOption] else {
                return
            }

            questionOptions.forEach { option in
                guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                rawQuestions[identifier] = selectedOption
            }

            if zaritScaleProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateZaritScaleProgress(with: .init(questions: rawQuestions, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
