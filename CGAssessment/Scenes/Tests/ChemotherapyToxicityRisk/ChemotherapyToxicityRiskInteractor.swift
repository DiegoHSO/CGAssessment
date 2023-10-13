//
//  ChemotherapyToxicityRiskInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 13/10/23.
//

import Foundation
import OSLog

protocol ChemotherapyToxicityRiskLogic: ActionButtonDelegate, SelectableViewDelegate {
    func controllerDidLoad()
}

class ChemotherapyToxicityRiskInteractor: ChemotherapyToxicityRiskLogic {

    // MARK: - Private Properties

    private var presenter: ChemotherapyToxicityRiskPresentationLogic?
    private var worker: ChemotherapyToxicityRiskWorker?
    private var cgaId: UUID?
    private var gender: Gender?
    private var birthDate: Date?
    private var rawQuestions: ChemotherapyToxicityRiskModels.RawQuestions = [
        .chemotherapyToxicityRiskQuestionOne: .none, .chemotherapyToxicityRiskQuestionTwo: .none, .chemotherapyToxicityRiskQuestionThree: .none,
        .chemotherapyToxicityRiskQuestionFour: .none, .chemotherapyToxicityRiskQuestionFive: .none, .chemotherapyToxicityRiskQuestionSix: .none,
        .chemotherapyToxicityRiskQuestionSeven: .none, .chemotherapyToxicityRiskQuestionEight: .none, .chemotherapyToxicityRiskQuestionNine: .none,
        .chemotherapyToxicityRiskQuestionTen: .none
    ]

    // MARK: - Init

    init(presenter: ChemotherapyToxicityRiskPresentationLogic, worker: ChemotherapyToxicityRiskWorker, cgaId: UUID?) {
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

    private func createViewModel() -> ChemotherapyToxicityRiskModels.ControllerViewModel {
        let questionFourOptionOneFormatted = switch gender {
        case .female:
            LocalizedTable.chemotherapyToxicityRiskQuestionFourOptionOneFemale
        case .male:
            LocalizedTable.chemotherapyToxicityRiskQuestionFourOptionOneMale
        default:
            LocalizedTable.none
        }

        let questionFourOptionTwoFormatted = switch gender {
        case .female:
            LocalizedTable.chemotherapyToxicityRiskQuestionFourOptionTwoFemale
        case .male:
            LocalizedTable.chemotherapyToxicityRiskQuestionFourOptionTwoMale
        default:
            LocalizedTable.none
        }

        let questions: [ChemotherapyToxicityRiskModels.QuestionViewModel] = [.init(question: .chemotherapyToxicityRiskQuestionEleven, selectedOption: rawQuestions[.chemotherapyToxicityRiskQuestionEleven] ?? .none,
                                                                                   options: [.firstOption: .chemotherapyToxicityRiskQuestionElevenOptionOne,
                                                                                             .secondOption: .chemotherapyToxicityRiskQuestionElevenOptionTwo]),
                                                                             .init(question: .chemotherapyToxicityRiskQuestionOne, selectedOption: rawQuestions[.chemotherapyToxicityRiskQuestionOne] ?? .none,
                                                                                   options: [.firstOption: .chemotherapyToxicityRiskQuestionOneOptionOne,
                                                                                             .secondOption: .chemotherapyToxicityRiskQuestionOneOptionTwo]),
                                                                             .init(question: .chemotherapyToxicityRiskQuestionTwo, selectedOption: rawQuestions[.chemotherapyToxicityRiskQuestionTwo] ?? .none,
                                                                                   options: [.firstOption: .chemotherapyToxicityRiskQuestionTwoOptionOne,
                                                                                             .secondOption: .chemotherapyToxicityRiskQuestionTwoOptionTwo]),
                                                                             .init(question: .chemotherapyToxicityRiskQuestionThree, selectedOption: rawQuestions[.chemotherapyToxicityRiskQuestionThree] ?? .none,
                                                                                   options: [.firstOption: .chemotherapyToxicityRiskQuestionThreeOptionOne,
                                                                                             .secondOption: .chemotherapyToxicityRiskQuestionThreeOptionTwo]),
                                                                             .init(question: .chemotherapyToxicityRiskQuestionFour, selectedOption: rawQuestions[.chemotherapyToxicityRiskQuestionFour] ?? .none,
                                                                                   options: [.firstOption: questionFourOptionOneFormatted,
                                                                                             .secondOption: questionFourOptionTwoFormatted]),
                                                                             .init(question: .chemotherapyToxicityRiskQuestionFive, selectedOption: rawQuestions[.chemotherapyToxicityRiskQuestionFive] ?? .none,
                                                                                   options: [.firstOption: .chemotherapyToxicityRiskQuestionFiveOptionOne,
                                                                                             .secondOption: .chemotherapyToxicityRiskQuestionFiveOptionTwo]),
                                                                             .init(question: .chemotherapyToxicityRiskQuestionSix, selectedOption: rawQuestions[.chemotherapyToxicityRiskQuestionSix] ?? .none,
                                                                                   options: [.firstOption: .yesKey,
                                                                                             .secondOption: .noKey]),
                                                                             .init(question: .chemotherapyToxicityRiskQuestionSeven, selectedOption: rawQuestions[.chemotherapyToxicityRiskQuestionSeven] ?? .none,
                                                                                   options: [.firstOption: .yesKey,
                                                                                             .secondOption: .noKey]),
                                                                             .init(question: .chemotherapyToxicityRiskQuestionEight, selectedOption: rawQuestions[.chemotherapyToxicityRiskQuestionEight] ?? .none,
                                                                                   options: [.firstOption: .chemotherapyToxicityRiskQuestionEightOptionOne,
                                                                                             .secondOption: .chemotherapyToxicityRiskQuestionEightOptionTwo]),
                                                                             .init(question: .chemotherapyToxicityRiskQuestionNine, selectedOption: rawQuestions[.chemotherapyToxicityRiskQuestionNine] ?? .none,
                                                                                   options: [.firstOption: .chemotherapyToxicityRiskQuestionNineOptionOne,
                                                                                             .secondOption: .chemotherapyToxicityRiskQuestionNineOptionTwo]),
                                                                             .init(question: .chemotherapyToxicityRiskQuestionTen, selectedOption: rawQuestions[.chemotherapyToxicityRiskQuestionTen] ?? .none,
                                                                                   options: [.firstOption: .chemotherapyToxicityRiskQuestionTenOptionOne,
                                                                                             .secondOption: .noKey])]
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
            presenter?.route(toRoute: .testResults(test: .chemotherapyToxicityRisk, results: .init(questions: rawQuestions), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        gender = try? worker?.getPatientGender()
        birthDate = try? worker?.getPatientBirthDate()

        if let chemotherapyToxicityRiskProgress = try? worker?.getChemotherapyToxicityRiskProgress() {
            guard let questionOptions = chemotherapyToxicityRiskProgress.selectableOptions?.allObjects as? [SelectableOption] else {
                return
            }

            questionOptions.forEach { option in
                guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                rawQuestions[identifier] = selectedOption
            }

            if chemotherapyToxicityRiskProgress.isDone {
                handleNavigation()
            }
        }

        rawQuestions[.chemotherapyToxicityRiskQuestionEleven] = (birthDate?.yearSinceCurrentDate ?? 0) < 72 ? .secondOption : .firstOption
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateChemotherapyToxicityRiskProgress(with: .init(questions: rawQuestions, isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
