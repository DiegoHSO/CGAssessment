//
//  KatzScaleInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation
import OSLog

protocol KatzScaleLogic: ActionButtonDelegate, SelectableViewDelegate {
    func controllerDidLoad()
}

class KatzScaleInteractor: KatzScaleLogic {

    // MARK: - Private Properties

    private var presenter: KatzScalePresentationLogic?
    private var worker: KatzScaleWorker?
    private var cgaId: UUID?
    private var rawQuestions: KatzScaleModels.RawQuestions = [
        .katzScaleQuestionOne: .none, .katzScaleQuestionTwo: .none, .katzScaleQuestionThree: .none,
        .katzScaleQuestionFour: .none, .katzScaleQuestionFive: .none, .katzScaleQuestionSix: .none
    ]
    private var questionsOrder: KatzScaleModels.QuestionsOrder = [
        .katzScaleQuestionOne: 1, .katzScaleQuestionTwo: 2, .katzScaleQuestionThree: 3,
        .katzScaleQuestionFour: 4, .katzScaleQuestionFive: 5, .katzScaleQuestionSix: 6
    ]

    // MARK: - Init

    init(presenter: KatzScalePresentationLogic, worker: KatzScaleWorker, cgaId: UUID?) {
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

    private func createViewModel() -> KatzScaleModels.ControllerViewModel {
        let questions: [KatzScaleModels.QuestionViewModel] = rawQuestions.map {
            return .init(question: $0.key, selectedOption: $0.value, options: [.firstOption: .yesKey, .secondOption: .noKey])
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
            presenter?.route(toRoute: .testResults(test: .katzScale, results: .init(questions: rawQuestions), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        if let katzScaleProgress = try? worker?.getKatzScaleProgress() {
            guard let questionOptions = katzScaleProgress.selectableOptions?.allObjects as? [SelectableOption] else {
                return
            }

            questionOptions.forEach { option in
                guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                rawQuestions[identifier] = selectedOption
            }

            if katzScaleProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateKatzScaleProgress(with: .init(questions: rawQuestions, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
