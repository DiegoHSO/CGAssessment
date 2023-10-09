//
//  GeriatricDepressionScaleInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 09/10/23.
//

import Foundation
import OSLog

protocol GeriatricDepressionScaleLogic: ActionButtonDelegate, SelectableViewDelegate {
    func controllerDidLoad()
}

class GeriatricDepressionScaleInteractor: GeriatricDepressionScaleLogic {

    // MARK: - Private Properties

    private var presenter: GeriatricDepressionScalePresentationLogic?
    private var worker: GeriatricDepressionScaleWorker?
    private var cgaId: UUID?
    private var rawQuestions: GeriatricDepressionScaleModels.RawQuestions = [
        .geriatricDepressionScaleQuestionOne: .none, .geriatricDepressionScaleQuestionTwo: .none, .geriatricDepressionScaleQuestionThree: .none,
        .geriatricDepressionScaleQuestionFour: .none, .geriatricDepressionScaleQuestionFive: .none, .geriatricDepressionScaleQuestionSix: .none,
        .geriatricDepressionScaleQuestionSeven: .none, .geriatricDepressionScaleQuestionEight: .none, .geriatricDepressionScaleQuestionNine: .none,
        .geriatricDepressionScaleQuestionTen: .none, .geriatricDepressionScaleQuestionEleven: .none, .geriatricDepressionScaleQuestionTwelve: .none,
        .geriatricDepressionScaleQuestionThirteen: .none, .geriatricDepressionScaleQuestionFourteen: .none, .geriatricDepressionScaleQuestionFifteen: .none
    ]
    private var questionsOrder: GeriatricDepressionScaleModels.QuestionsOrder = [
        .geriatricDepressionScaleQuestionOne: 1, .geriatricDepressionScaleQuestionTwo: 2, .geriatricDepressionScaleQuestionThree: 3,
        .geriatricDepressionScaleQuestionFour: 4, .geriatricDepressionScaleQuestionFive: 5, .geriatricDepressionScaleQuestionSix: 6,
        .geriatricDepressionScaleQuestionSeven: 7, .geriatricDepressionScaleQuestionEight: 8, .geriatricDepressionScaleQuestionNine: 9,
        .geriatricDepressionScaleQuestionTen: 10, .geriatricDepressionScaleQuestionEleven: 11, .geriatricDepressionScaleQuestionTwelve: 12,
        .geriatricDepressionScaleQuestionThirteen: 13, .geriatricDepressionScaleQuestionFourteen: 14, .geriatricDepressionScaleQuestionFifteen: 15
    ]

    // MARK: - Init

    init(presenter: GeriatricDepressionScalePresentationLogic, worker: GeriatricDepressionScaleWorker, cgaId: UUID?) {
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

    private func createViewModel() -> GeriatricDepressionScaleModels.ControllerViewModel {
        let questions: [GeriatricDepressionScaleModels.QuestionViewModel] = rawQuestions.map {
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
            presenter?.route(toRoute: .testResults(test: .geriatricDepressionScale, results: .init(questions: rawQuestions), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        if let geriatricDepressionScaleProgress = try? worker?.getGeriatricDepressionScaleProgress() {
            guard let questionOptions = geriatricDepressionScaleProgress.selectableOptions?.allObjects as? [SelectableOption] else {
                return
            }

            questionOptions.forEach { option in
                guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                rawQuestions[identifier] = selectedOption
            }

            if geriatricDepressionScaleProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateGeriatricDepressionScaleProgress(with: .init(questions: rawQuestions, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
