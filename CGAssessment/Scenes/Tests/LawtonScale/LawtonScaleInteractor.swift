//
//  LawtonScaleInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 11/10/23.
//

import Foundation
import OSLog

protocol LawtonScaleLogic: ActionButtonDelegate, SelectableViewDelegate {
    func controllerDidLoad()
}

class LawtonScaleInteractor: LawtonScaleLogic {

    // MARK: - Private Properties

    private var presenter: LawtonScalePresentationLogic?
    private var worker: LawtonScaleWorker?
    private var cgaId: UUID?
    private var rawQuestions: LawtonScaleModels.RawQuestions = [
        .telephone: .none, .trips: .none, .shopping: .none, .mealPreparation: .none,
        .housework: .none, .medicine: .none, .money: .none
    ]

    // MARK: - Init

    init(presenter: LawtonScalePresentationLogic, worker: LawtonScaleWorker, cgaId: UUID?) {
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
        let section: LocalizedTable = switch value {
        case .lawtonScaleQuestionOneOptionOne, .lawtonScaleQuestionOneOptionTwo, .lawtonScaleQuestionOneOptionThree:
            .telephone
        case .lawtonScaleQuestionTwoOptionOne, .lawtonScaleQuestionTwoOptionTwo, .lawtonScaleQuestionTwoOptionThree:
            .trips
        case .lawtonScaleQuestionThreeOptionOne, .lawtonScaleQuestionThreeOptionTwo, .lawtonScaleQuestionThreeOptionThree:
            .shopping
        case .lawtonScaleQuestionFourOptionOne, .lawtonScaleQuestionFourOptionTwo, .lawtonScaleQuestionFourOptionThree:
            .mealPreparation
        case .lawtonScaleQuestionFiveOptionOne, .lawtonScaleQuestionFiveOptionTwo, .lawtonScaleQuestionFiveOptionThree:
            .housework
        case .lawtonScaleQuestionSixOptionOne, .lawtonScaleQuestionSixOptionTwo, .lawtonScaleQuestionSixOptionThree:
            .medicine
        case .lawtonScaleQuestionSevenOptionOne, .lawtonScaleQuestionSevenOptionTwo, .lawtonScaleQuestionSevenOptionThree:
            .money
        default:
            .none
        }

        rawQuestions[section] = option

        updateDatabase()
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> LawtonScaleModels.ControllerViewModel {
        let questions: LawtonScaleModels.Questions = [.firstQuestion: .init(question: nil, selectedOption: rawQuestions[.telephone] ?? .none,
                                                                            options: [.firstOption: .lawtonScaleQuestionOneOptionOne,
                                                                                      .secondOption: .lawtonScaleQuestionOneOptionTwo,
                                                                                      .thirdOption: .lawtonScaleQuestionOneOptionThree]),
                                                      .secondQuestion: .init(question: nil, selectedOption: rawQuestions[.trips] ?? .none,
                                                                             options: [.firstOption: .lawtonScaleQuestionTwoOptionOne,
                                                                                       .secondOption: .lawtonScaleQuestionTwoOptionTwo,
                                                                                       .thirdOption: .lawtonScaleQuestionTwoOptionThree]),
                                                      .thirdQuestion: .init(question: nil, selectedOption: rawQuestions[.shopping] ?? .none,
                                                                            options: [.firstOption: .lawtonScaleQuestionThreeOptionOne,
                                                                                      .secondOption: .lawtonScaleQuestionThreeOptionTwo,
                                                                                      .thirdOption: .lawtonScaleQuestionThreeOptionThree]),
                                                      .fourthQuestion: .init(question: nil, selectedOption: rawQuestions[.mealPreparation] ?? .none,
                                                                             options: [.firstOption: .lawtonScaleQuestionFourOptionOne,
                                                                                       .secondOption: .lawtonScaleQuestionFourOptionTwo,
                                                                                       .thirdOption: .lawtonScaleQuestionFourOptionThree]),
                                                      .fifthQuestion: .init(question: nil, selectedOption: rawQuestions[.housework] ?? .none,
                                                                            options: [.firstOption: .lawtonScaleQuestionFiveOptionOne,
                                                                                      .secondOption: .lawtonScaleQuestionFiveOptionTwo,
                                                                                      .thirdOption: .lawtonScaleQuestionFiveOptionThree]),
                                                      .sixthQuestion: .init(question: nil, selectedOption: rawQuestions[.medicine] ?? .none,
                                                                            options: [.firstOption: .lawtonScaleQuestionSixOptionOne,
                                                                                      .secondOption: .lawtonScaleQuestionSixOptionTwo,
                                                                                      .thirdOption: .lawtonScaleQuestionSixOptionThree]),
                                                      .seventhQuestion: .init(question: nil, selectedOption: rawQuestions[.money] ?? .none,
                                                                              options: [.firstOption: .lawtonScaleQuestionOneOptionOne,
                                                                                        .secondOption: .lawtonScaleQuestionOneOptionTwo,
                                                                                        .thirdOption: .lawtonScaleQuestionOneOptionThree])
        ]

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
            presenter?.route(toRoute: .testResults(test: .lawtonScale, results: .init(questions: rawQuestions), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        if let lawtonScaleProgress = try? worker?.getLawtonScaleProgress() {
            guard let questionOptions = lawtonScaleProgress.selectableOptions?.allObjects as? [SelectableOption] else {
                return
            }

            questionOptions.forEach { option in
                guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                rawQuestions[identifier] = selectedOption
            }

            if lawtonScaleProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateLawtonScaleProgress(with: .init(questions: rawQuestions, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
