//
//  MiniMentalStateExamInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 05/10/23.
//

import Foundation
import OSLog

protocol MiniMentalStateExamLogic: ActionButtonDelegate, SelectableViewDelegate, BinaryOptionDelegate {
    func controllerDidLoad()
}

class MiniMentalStateExamInteractor: MiniMentalStateExamLogic {

    // MARK: - Private Properties

    private var presenter: MiniMentalStateExamPresentationLogic?
    private var worker: MiniMentalStateExamWorker?
    private var cgaId: UUID?

    private var firstQuestionOption: SelectableKeys = .none
    private var secondQuestionOption: SelectableKeys = .none
    private var thirdQuestionOption: SelectableKeys = .none
    private var fourthQuestionOption: SelectableKeys = .none
    private var fifthQuestionOption: SelectableKeys = .none

    private var firstBinaryOptionForFirstSection: SelectableBinaryKeys = .none
    private var secondBinaryOptionForFirstSection: SelectableBinaryKeys = .none
    private var thirdBinaryOptionForFirstSection: SelectableBinaryKeys = .none
    private var fourthBinaryOptionForFirstSection: SelectableBinaryKeys = .none
    private var fifthBinaryOptionForFirstSection: SelectableBinaryKeys = .none

    private var firstBinaryOptionForSecondSection: SelectableBinaryKeys = .none
    private var secondBinaryOptionForSecondSection: SelectableBinaryKeys = .none
    private var thirdBinaryOptionForSecondSection: SelectableBinaryKeys = .none
    private var fourthBinaryOptionForSecondSection: SelectableBinaryKeys = .none
    private var fifthBinaryOptionForSecondSection: SelectableBinaryKeys = .none

    private var firstBinaryOptionForThirdSection: SelectableBinaryKeys = .none
    private var secondBinaryOptionForThirdSection: SelectableBinaryKeys = .none
    private var thirdBinaryOptionForThirdSection: SelectableBinaryKeys = .none

    private var firstBinaryOptionForFourthSection: SelectableBinaryKeys = .none
    private var secondBinaryOptionForFourthSection: SelectableBinaryKeys = .none
    private var thirdBinaryOptionForFourthSection: SelectableBinaryKeys = .none
    private var fourthBinaryOptionForFourthSection: SelectableBinaryKeys = .none
    private var fifthBinaryOptionForFourthSection: SelectableBinaryKeys = .none

    private var firstBinaryOptionForFifthSection: SelectableBinaryKeys = .none
    private var secondBinaryOptionForFifthSection: SelectableBinaryKeys = .none
    private var thirdBinaryOptionForFifthSection: SelectableBinaryKeys = .none

    private var firstBinaryOptionForSixthSection: SelectableBinaryKeys = .none
    private var secondBinaryOptionForSixthSection: SelectableBinaryKeys = .none

    private var firstBinaryOptionForSeventhSection: SelectableBinaryKeys = .none
    private var secondBinaryOptionForSeventhSection: SelectableBinaryKeys = .none
    private var thirdBinaryOptionForSeventhSection: SelectableBinaryKeys = .none

    private var gender: Gender?

    // MARK: - Init

    init(presenter: MiniMentalStateExamPresentationLogic, worker: MiniMentalStateExamWorker, cgaId: UUID?) {
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
        switch value {
        case .miniMentalStateExamFirstQuestion:
            firstQuestionOption = option
        case .miniMentalStateExamSecondQuestion:
            secondQuestionOption = option
        case .miniMentalStateExamThirdQuestion:
            thirdQuestionOption = option
        case .miniMentalStateExamFourthQuestion:
            fourthQuestionOption = option
        default:
            fifthQuestionOption = option
        }

        updateDatabase()
        sendDataToPresenter()
    }

    func didSelect(option: SelectableBinaryKeys, numberIdentifier: Int, sectionIdentifier: LocalizedTable) {
        switch sectionIdentifier {
        case .miniMentalStateExamFirstSectionQuestion where numberIdentifier == 1:
            firstBinaryOptionForFirstSection = option
        case .miniMentalStateExamFirstSectionQuestion where numberIdentifier == 2:
            secondBinaryOptionForFirstSection = option
        case .miniMentalStateExamFirstSectionQuestion where numberIdentifier == 3:
            thirdBinaryOptionForFirstSection = option
        case .miniMentalStateExamFirstSectionQuestion where numberIdentifier == 4:
            fourthBinaryOptionForFirstSection = option
        case .miniMentalStateExamFirstSectionQuestion where numberIdentifier == 5:
            fifthBinaryOptionForFirstSection = option

        case .miniMentalStateExamSecondSectionQuestion where numberIdentifier == 1:
            firstBinaryOptionForSecondSection = option
        case .miniMentalStateExamSecondSectionQuestion where numberIdentifier == 2:
            secondBinaryOptionForSecondSection = option
        case .miniMentalStateExamSecondSectionQuestion where numberIdentifier == 3:
            thirdBinaryOptionForSecondSection = option
        case .miniMentalStateExamSecondSectionQuestion where numberIdentifier == 4:
            fourthBinaryOptionForSecondSection = option
        case .miniMentalStateExamSecondSectionQuestion where numberIdentifier == 5:
            fifthBinaryOptionForSecondSection = option

        case .miniMentalStateExamThirdSectionQuestion where numberIdentifier == 1:
            firstBinaryOptionForThirdSection = option
        case .miniMentalStateExamThirdSectionQuestion where numberIdentifier == 2:
            secondBinaryOptionForThirdSection = option
        case .miniMentalStateExamThirdSectionQuestion where numberIdentifier == 3:
            thirdBinaryOptionForThirdSection = option

        case .miniMentalStateExamFourthSectionQuestion where numberIdentifier == 1:
            firstBinaryOptionForFourthSection = option
        case .miniMentalStateExamFourthSectionQuestion where numberIdentifier == 2:
            secondBinaryOptionForFourthSection = option
        case .miniMentalStateExamFourthSectionQuestion where numberIdentifier == 3:
            thirdBinaryOptionForFourthSection = option
        case .miniMentalStateExamFourthSectionQuestion where numberIdentifier == 4:
            fourthBinaryOptionForFourthSection = option
        case .miniMentalStateExamFourthSectionQuestion where numberIdentifier == 5:
            fifthBinaryOptionForFourthSection = option

        case .miniMentalStateExamFifthSectionQuestion where numberIdentifier == 1:
            firstBinaryOptionForFifthSection = option
        case .miniMentalStateExamFifthSectionQuestion where numberIdentifier == 2:
            secondBinaryOptionForFifthSection = option
        case .miniMentalStateExamFifthSectionQuestion where numberIdentifier == 3:
            thirdBinaryOptionForFifthSection = option

        case .miniMentalStateExamSixthSectionQuestion where numberIdentifier == 1:
            firstBinaryOptionForSixthSection = option
        case .miniMentalStateExamSixthSectionQuestion where numberIdentifier == 2:
            secondBinaryOptionForSixthSection = option

        case .miniMentalStateExamSeventhSectionQuestion where numberIdentifier == 1:
            firstBinaryOptionForSeventhSection = option
        case .miniMentalStateExamSeventhSectionQuestion where numberIdentifier == 2:
            secondBinaryOptionForSeventhSection = option
        case .miniMentalStateExamSeventhSectionQuestion where numberIdentifier == 3:
            thirdBinaryOptionForSeventhSection = option

        default:
            break
        }

        updateDatabase()
        sendDataToPresenter()
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> MiniMentalStateExamModels.ControllerViewModel {
        let questions: MiniMentalStateExamModels.Questions = [.firstQuestion: .init(question: .miniMentalStateExamFirstQuestion,
                                                                                    options: [.firstOption: .moreThanElevenYears,
                                                                                              .secondOption: .betweenNineAndElevenYears,
                                                                                              .thirdOption: .betweenFiveAndEightYears,
                                                                                              .fourthOption: .betweenOneAndFourYears, .fifthOption: .illiterate]),
                                                              .secondQuestion: .init(question: .miniMentalStateExamSecondQuestion,
                                                                                     options: [.firstOption: .repeatedSentence,
                                                                                               .secondOption: .couldntRepeatSentence]),
                                                              .thirdQuestion: .init(question: .miniMentalStateExamThirdQuestion,
                                                                                    options: [.firstOption: .executedTheOrder,
                                                                                              .secondOption: .didntExecuteTheOrder]),
                                                              .fourthQuestion: .init(question: .miniMentalStateExamFourthQuestion,
                                                                                     options: [.firstOption: .wroteCorrectly,
                                                                                               .secondOption: .didntWriteCorrectly]),
                                                              .fifthQuestion: .init(question: nil,
                                                                                    options: [.firstOption: .copiedTheDrawing,
                                                                                              .secondOption: .didntCopyTheDrawing])
        ]

        let firstBinarySectionQuestions: [Int: MiniMentalStateExamModels.BinaryOption] = [1: .init(question: .year, selectedOption: firstBinaryOptionForFirstSection),
                                                                                          2: .init(question: .month, selectedOption: secondBinaryOptionForFirstSection),
                                                                                          3: .init(question: .dayOfMonth, selectedOption: thirdBinaryOptionForFirstSection),
                                                                                          4: .init(question: .dayOfWeek, selectedOption: fourthBinaryOptionForFirstSection),
                                                                                          5: .init(question: .time, selectedOption: fifthBinaryOptionForFirstSection)]

        let secondBinarySectionQuestions: [Int: MiniMentalStateExamModels.BinaryOption] = [1: .init(question: .streetOrPlace, selectedOption: firstBinaryOptionForSecondSection),
                                                                                           2: .init(question: .floor, selectedOption: secondBinaryOptionForSecondSection),
                                                                                           3: .init(question: .neighborhoodOrNearStreet, selectedOption: thirdBinaryOptionForSecondSection),
                                                                                           4: .init(question: .city, selectedOption: fourthBinaryOptionForSecondSection),
                                                                                           5: .init(question: .state, selectedOption: fifthBinaryOptionForSecondSection)]

        let thirdBinarySectionQuestions: [Int: MiniMentalStateExamModels.BinaryOption] = [1: .init(question: .car, selectedOption: firstBinaryOptionForThirdSection),
                                                                                          2: .init(question: .vase, selectedOption: secondBinaryOptionForThirdSection),
                                                                                          3: .init(question: .brick, selectedOption: thirdBinaryOptionForThirdSection)]

        let fourthBinarySectionQuestions: [Int: MiniMentalStateExamModels.BinaryOption] = [1: .init(question: .firstCalculation, selectedOption: firstBinaryOptionForFourthSection),
                                                                                           2: .init(question: .secondCalculation, selectedOption: secondBinaryOptionForFourthSection),
                                                                                           3: .init(question: .thirdCalculation, selectedOption: thirdBinaryOptionForFourthSection),
                                                                                           4: .init(question: .fourthCalculation, selectedOption: fourthBinaryOptionForFourthSection),
                                                                                           5: .init(question: .fifthCalculation, selectedOption: fifthBinaryOptionForFourthSection)]

        let fifthBinarySectionQuestions: [Int: MiniMentalStateExamModels.BinaryOption] = [1: .init(question: .car, selectedOption: firstBinaryOptionForFifthSection),
                                                                                          2: .init(question: .vase, selectedOption: secondBinaryOptionForFifthSection),
                                                                                          3: .init(question: .brick, selectedOption: thirdBinaryOptionForFifthSection)]

        let sixthBinarySectionQuestions: [Int: MiniMentalStateExamModels.BinaryOption] = [1: .init(question: .clock, selectedOption: firstBinaryOptionForSixthSection),
                                                                                          2: .init(question: .pen, selectedOption: secondBinaryOptionForSixthSection)]

        let seventhBinarySectionQuestions: [Int: MiniMentalStateExamModels.BinaryOption] = [1: .init(question: .firstStage, selectedOption: firstBinaryOptionForSeventhSection),
                                                                                            2: .init(question: .secondStage, selectedOption: secondBinaryOptionForSeventhSection),
                                                                                            3: .init(question: .thirdStage, selectedOption: thirdBinaryOptionForSeventhSection)]

        let binaryQuestions: MiniMentalStateExamModels.BinaryQuestions = [.firstBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamFirstSectionQuestion,
                                                                                  questions: firstBinarySectionQuestions, firstOptionTitle: LocalizedTable.informed.localized, secondOptionTitle: LocalizedTable.didntInform.localized, delegate: self),
                                                                          .secondBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamSecondSectionQuestion,
                                                                                  questions: secondBinarySectionQuestions, firstOptionTitle: LocalizedTable.informed.localized, secondOptionTitle: LocalizedTable.didntInform.localized, delegate: self),
                                                                          .thirdBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamThirdSectionQuestion,
                                                                                  questions: thirdBinarySectionQuestions, firstOptionTitle: LocalizedTable.repeated.localized, secondOptionTitle: LocalizedTable.didntRepeat.localized, delegate: self),
                                                                          .fourthBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamFourthSectionQuestion,
                                                                                  questions: fourthBinarySectionQuestions, firstOptionTitle: LocalizedTable.gotIt.localized, secondOptionTitle: LocalizedTable.failed.localized, delegate: self),
                                                                          .fifthBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamFifthSectionQuestion,
                                                                                  questions: fifthBinarySectionQuestions, firstOptionTitle: LocalizedTable.repeated.localized, secondOptionTitle: LocalizedTable.didntRepeat.localized, delegate: self),
                                                                          .sixthBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamSixthSectionQuestion,
                                                                                  questions: sixthBinarySectionQuestions, firstOptionTitle: LocalizedTable.named.localized, secondOptionTitle: LocalizedTable.didntName.localized, delegate: self),
                                                                          .seventhBinaryQuestion:
                                                                            .init(title: .miniMentalStateExamSeventhSectionQuestion,
                                                                                  questions: seventhBinarySectionQuestions,
                                                                                  firstOptionTitle: LocalizedTable.carriedOut.localized,
                                                                                  secondOptionTitle: LocalizedTable.didntCarryOut.localized, delegate: self)]

        let selectedOptions = [firstQuestionOption, secondQuestionOption, thirdQuestionOption,
                               fourthQuestionOption, fifthQuestionOption]
        let selectedBinaryOptions = [firstBinaryOptionForFirstSection, secondBinaryOptionForFirstSection, thirdBinaryOptionForFirstSection,
                                     fourthBinaryOptionForFirstSection, fifthBinaryOptionForFirstSection, firstBinaryOptionForSecondSection,
                                     secondBinaryOptionForSecondSection, thirdBinaryOptionForSecondSection, fourthBinaryOptionForSecondSection,
                                     fifthBinaryOptionForSecondSection, firstBinaryOptionForThirdSection, secondBinaryOptionForThirdSection,
                                     thirdBinaryOptionForThirdSection, firstBinaryOptionForFourthSection, secondBinaryOptionForFourthSection,
                                     thirdBinaryOptionForFourthSection, fourthBinaryOptionForFourthSection, fifthBinaryOptionForFourthSection,
                                     firstBinaryOptionForFifthSection, secondBinaryOptionForFifthSection, thirdBinaryOptionForFifthSection,
                                     firstBinaryOptionForSixthSection, secondBinaryOptionForSixthSection, firstBinaryOptionForSeventhSection,
                                     secondBinaryOptionForSeventhSection, thirdBinaryOptionForSeventhSection]

        let isResultsButtonEnabled: Bool = selectedOptions.allSatisfy({$0 != .none}) && selectedBinaryOptions.allSatisfy({ $0 != .none })

        return .init(questions: questions, binaryQuestions: binaryQuestions, firstQuestionOption: firstQuestionOption,
                     secondQuestionOption: secondQuestionOption, thirdQuestionOption: thirdQuestionOption,
                     fourthQuestionOption: fourthQuestionOption, fifthQuestionOption: fifthQuestionOption,
                     isResultsButtonEnabled: isResultsButtonEnabled)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        let selectedOptions = [firstQuestionOption, secondQuestionOption, thirdQuestionOption,
                               fourthQuestionOption, fifthQuestionOption]

        if let gender, selectedOptions.allSatisfy({$0 != .none}) {
            presenter?.route(toRoute: .testResults(test: .sarcopeniaScreening, results: .init(firstQuestionOption: firstQuestionOption,
                                                                                              secondQuestionOption: secondQuestionOption,
                                                                                              thirdQuestionOption: thirdQuestionOption,
                                                                                              fourthQuestionOption: fourthQuestionOption,
                                                                                              fifthQuestionOption: fifthQuestionOption,
                                                                                              gender: gender), cgaId: cgaId))
        }
    }

    private func computeViewModelData() {
        gender = try? worker?.getPatientGender()
        /*
         if let sarcopeniaScreeningProgress = try? worker?.getMiniMentalStateExamProgress() {
         guard let firstQuestionOption = SelectableKeys(rawValue: sarcopeniaScreeningProgress.firstQuestionOption),
         let secondQuestionOption = SelectableKeys(rawValue: sarcopeniaScreeningProgress.secondQuestionOption),
         let thirdQuestionOption = SelectableKeys(rawValue: sarcopeniaScreeningProgress.thirdQuestionOption),
         let fourthQuestionOption = SelectableKeys(rawValue: sarcopeniaScreeningProgress.fourthQuestionOption),
         let fifthQuestionOption = SelectableKeys(rawValue: sarcopeniaScreeningProgress.fifthQuestionOption) else {
         return
         }

         self.firstQuestionOption = firstQuestionOption
         self.secondQuestionOption = secondQuestionOption
         self.thirdQuestionOption = thirdQuestionOption
         self.fourthQuestionOption = fourthQuestionOption
         self.fifthQuestionOption = fifthQuestionOption

         if sarcopeniaScreeningProgress.isDone {
         handleNavigation()
         }
         }
         */
    }

    private func updateDatabase(isDone: Bool = false) {
        /*
         do {
         try worker?.updateMiniMentalStateExamProgress(with: .init(firstQuestionOption: firstQuestionOption, secondQuestionOption: secondQuestionOption,
         thirdQuestionOption: thirdQuestionOption, fourthQuestionOption: fourthQuestionOption,
         fifthQuestionOption: fifthQuestionOption, isDone: isDone))
         } catch {
         os_log("Error: %@", log: .default, type: .error, String(describing: error))
         }
         */
    }
}
