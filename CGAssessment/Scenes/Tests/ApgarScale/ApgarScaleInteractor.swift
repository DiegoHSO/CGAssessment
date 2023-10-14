//
//  ApgarScaleInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 12/10/23.
//

import Foundation
import OSLog

protocol ApgarScaleLogic: ActionButtonDelegate, SelectableViewDelegate {
    func controllerDidLoad()
}

class ApgarScaleInteractor: ApgarScaleLogic {

    // MARK: - Private Properties

    private var presenter: ApgarScalePresentationLogic?
    private var worker: ApgarScaleWorker?
    private var cgaId: UUID?
    private var rawQuestions: ApgarScaleModels.RawQuestions = [
        .apgarScaleQuestionOne: .none, .apgarScaleQuestionTwo: .none, .apgarScaleQuestionThree: .none,
        .apgarScaleQuestionFour: .none, .apgarScaleQuestionFive: .none
    ]
    private var questionsOrder: ApgarScaleModels.QuestionsOrder = [
        .apgarScaleQuestionOne: 1, .apgarScaleQuestionTwo: 2, .apgarScaleQuestionThree: 3,
        .apgarScaleQuestionFour: 4, .apgarScaleQuestionFive: 5
    ]

    // MARK: - Init

    init(presenter: ApgarScalePresentationLogic, worker: ApgarScaleWorker, cgaId: UUID?) {
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

    private func createViewModel() -> ApgarScaleModels.ControllerViewModel {
        let questions: [ApgarScaleModels.QuestionViewModel] = rawQuestions.map {
            return .init(question: $0.key, selectedOption: $0.value, options: [.firstOption: .rarely, .secondOption: .occasionally, .thirdOption: .frequently])
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
            presenter?.route(toRoute: .testResults(test: .apgarScale, results: .init(questions: rawQuestions), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        if let apgarScaleProgress = try? worker?.getApgarScaleProgress() {
            guard let questionOptions = apgarScaleProgress.selectableOptions?.allObjects as? [SelectableOption] else {
                return
            }

            questionOptions.forEach { option in
                guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                rawQuestions[identifier] = selectedOption
            }

            if apgarScaleProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateApgarScaleProgress(with: .init(questions: rawQuestions, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
