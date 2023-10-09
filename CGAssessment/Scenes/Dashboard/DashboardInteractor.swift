//
//  DashboardInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 17/09/23.
//

import Foundation

protocol DashboardLogic: FeatureComponentDelegate, NoTodoEvaluationDelegate, NoRecentApplicationDelegate {
    func controllerDidLoad()
    func controllerWillDisappear()
    func didSelect(menuOption: DashboardModels.MenuOption)
}

class DashboardInteractor: DashboardLogic {

    // MARK: - Private Properties

    private var presenter: DashboardPresentationLogic?
    private var worker: DashboardWorker?
    private var resultsWorker: ResultsWorker?
    private var recentCGA: DashboardModels.LatestCGAViewModel?
    private var todoEvaluations: [DashboardModels.TodoEvaluationViewModel] = []

    // MARK: - Init

    init(presenter: DashboardPresentationLogic, worker: DashboardWorker, resultsWorker: ResultsWorker? = ResultsWorker()) {
        self.presenter = presenter
        self.worker = worker
        self.resultsWorker = resultsWorker
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        setupNotification()
        computeViewModelData()
        sendDataToPresenter()
    }

    func controllerWillDisappear() {
        // swiftlint:disable:next notification_center_detachment
        NotificationCenter.default.removeObserver(self)
    }

    func didSelect(menuOption: DashboardModels.MenuOption) {
        switch menuOption {
        case .patients:
            presenter?.route(toRoute: .patients)
        case .cgas:
            presenter?.route(toRoute: .cgas)
        case .newCGA:
            presenter?.route(toRoute: .patients)
        case .reports:
            presenter?.route(toRoute: .reports)
        case .cgaDomains:
            presenter?.route(toRoute: .cgaDomains)
        case .cgaExample:
            presenter?.route(toRoute: .cga(cgaId: nil))
        case .evaluation(let id):
            presenter?.route(toRoute: .cga(cgaId: id))
        case .lastCGA:
            presenter?.route(toRoute: .cga(cgaId: recentCGA?.id))
        }
    }

    // MARK: - Private Methods

    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData),
                                               name: .NSPersistentStoreRemoteChange,
                                               object: nil)
    }

    @objc
    private func updateData() {
        DispatchQueue.main.async {
            self.computeViewModelData()
            self.sendDataToPresenter()
        }
    }

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> DashboardModels.ViewModel {
        return DashboardModels.ViewModel(latestEvaluation: recentCGA, todoEvaluations: todoEvaluations)
    }

    private func computeViewModelData() {
        computeLatestCGAData()
        computeTodoEvaluationsData()
    }

    private func computeLatestCGAData() {
        guard let latestCGA = try? worker?.getLatestCGA(), let patientName = latestCGA.patient?.name,
              let birthDate = latestCGA.patient?.birthDate, let id = latestCGA.cgaId else { return }

        var missingDomains: Int = 9

        // MARK: - Mobility domain done check

        if let isFirstTestDone = latestCGA.timedUpAndGo?.isDone, isFirstTestDone, let isSecondTestDone = latestCGA.walkingSpeed?.isDone,
           isSecondTestDone, let isThirdTestDone = latestCGA.calfCircumference?.isDone, isThirdTestDone,
           let isFourthTestDone = latestCGA.gripStrength?.isDone, isFourthTestDone,
           let isFifthTestDone = latestCGA.sarcopeniaScreening?.isDone, isFifthTestDone {
            missingDomains -= 1
        }

        // MARK: - Cognitive domain done check

        if let isFirstTestDone = latestCGA.miniMentalStateExam?.isDone, isFirstTestDone,
           let isSecondTestDone = latestCGA.verbalFluency?.isDone, isSecondTestDone,
           let isThirdTestDone = latestCGA.clockDrawing?.isDone, isThirdTestDone,
           let isFourthTestDone = latestCGA.moCA?.isDone, isFourthTestDone,
           let isFifthTestDone = latestCGA.geriatricDepressionScale?.isDone, isFifthTestDone {
            missingDomains -= 1
        }

        // MARK: - Sensory domain done check

        recentCGA = .init(patientName: patientName, patientAge: birthDate.yearSinceCurrentDate, missingDomains: missingDomains, id: id)
    }

    private func computeTodoEvaluationsData() {
        guard let todoEvaluations = try? worker?.getClosestCGAs() else { return }

        self.todoEvaluations = todoEvaluations.compactMap({ evaluation in
            guard let patient = evaluation.patient, let patientName = patient.name, let birthDate = patient.birthDate,
                  let lastModification = evaluation.lastModification, let id = evaluation.cgaId else { return nil }

            let gender = Gender(rawValue: patient.gender) ?? .female
            var alteredDomains = 0

            // MARK: - Mobility domain test results check

            var isMobilityDomainAltered: Bool = false
            var timedUpAndGoResults: TimedUpAndGoModels.TestResults?
            var walkingSpeedResults: WalkingSpeedModels.TestResults?
            var calfCircumferenceResults: CalfCircumferenceModels.TestResults?
            var gripStrengthResults: GripStrengthModels.TestResults?

            if let timedUpAndGo = evaluation.timedUpAndGo, timedUpAndGo.isDone {
                timedUpAndGoResults = TimedUpAndGoModels.TestResults(elapsedTime: timedUpAndGo.hasStopwatch ?
                                                                        timedUpAndGo.typedTime as? Double ?? 0 :
                                                                        timedUpAndGo.measuredTime as? Double ?? 0)

                let resultsTuple = resultsWorker?.getResults(for: .timedUpAndGo, results: timedUpAndGoResults)
                if resultsTuple?.1 == .bad || resultsTuple?.1 == .medium { isMobilityDomainAltered = true }
            }

            if let walkingSpeed = evaluation.walkingSpeed, walkingSpeed.isDone, !isMobilityDomainAltered {
                if walkingSpeed.hasStopwatch {
                    walkingSpeedResults = WalkingSpeedModels.TestResults(firstElapsedTime: walkingSpeed.firstTypedTime as? Double ?? 0,
                                                                         secondElapsedTime: walkingSpeed.secondTypedTime as? Double ?? 0,
                                                                         thirdElapsedTime: walkingSpeed.thirdTypedTime as? Double ?? 0)
                } else {
                    walkingSpeedResults = WalkingSpeedModels.TestResults(firstElapsedTime: walkingSpeed.firstMeasuredTime as? Double ?? 0,
                                                                         secondElapsedTime: walkingSpeed.secondMeasuredTime as? Double ?? 0,
                                                                         thirdElapsedTime: walkingSpeed.thirdMeasuredTime as? Double ?? 0)
                }

                let resultsTuple = resultsWorker?.getResults(for: .walkingSpeed, results: walkingSpeedResults)
                if resultsTuple?.1 == .bad { isMobilityDomainAltered = true }
            }

            if let calfCircumference = evaluation.calfCircumference, calfCircumference.isDone, !isMobilityDomainAltered {
                calfCircumferenceResults = CalfCircumferenceModels.TestResults(circumference: calfCircumference.measuredCircumference as? Double ?? 0)
                let resultsTuple = resultsWorker?.getResults(for: .calfCircumference, results: calfCircumferenceResults)
                if resultsTuple?.1 == .bad { isMobilityDomainAltered = true }
            }

            if let gripStrength = evaluation.gripStrength, gripStrength.isDone, !isMobilityDomainAltered {
                gripStrengthResults = GripStrengthModels.TestResults(firstMeasurement: gripStrength.firstMeasurement as? Double ?? 0,
                                                                     secondMeasurement: gripStrength.secondMeasurement as? Double ?? 0,
                                                                     thirdMeasurement: gripStrength.thirdMeasurement as? Double ?? 0,
                                                                     gender: gender)

                let resultsTuple = resultsWorker?.getResults(for: .gripStrength, results: gripStrengthResults)
                if resultsTuple?.1 == .bad { isMobilityDomainAltered = true }
            }

            if let sarcopeniaAssessment = evaluation.sarcopeniaAssessment, sarcopeniaAssessment.isDone, !isMobilityDomainAltered,
               let timedUpAndGoResults, let walkingSpeedResults, let calfCircumferenceResults, let gripStrengthResults {

                let results = SarcopeniaAssessmentModels.TestResults(gripStrengthResults: gripStrengthResults,
                                                                     calfCircumferenceResults: calfCircumferenceResults,
                                                                     timedUpAndGoResults: timedUpAndGoResults,
                                                                     walkingSpeedResults: walkingSpeedResults)

                let resultsTuple = resultsWorker?.getResults(for: .sarcopeniaAssessment, results: results)
                if resultsTuple?.1 == .bad || resultsTuple?.1 == .medium || resultsTuple?.1 == .good { isMobilityDomainAltered = true }
            }

            alteredDomains = isMobilityDomainAltered ? alteredDomains + 1 : alteredDomains

            // MARK: - Cognitive domain test results check

            var isCognitiveDomainAltered: Bool = false

            if let miniMentalStateExam = evaluation.miniMentalStateExam, miniMentalStateExam.isDone {
                var rawQuestions: MiniMentalStateExamModels.RawQuestions = [:]
                var rawBinaryQuestions: MiniMentalStateExamModels.RawBinaryQuestions = [:]

                guard let binaryOptions = miniMentalStateExam.binaryOptions?.allObjects as? [BinaryOption],
                      let questionOptions = miniMentalStateExam.selectableOptions?.allObjects as? [SelectableOption] else {
                    return nil
                }

                questionOptions.forEach { option in
                    guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                          let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                    rawQuestions[identifier] = selectedOption
                }

                binaryOptions.forEach { option in
                    guard let selectedOption = SelectableBinaryKeys(rawValue: option.selectedOption),
                          let identifier = LocalizedTable(rawValue: option.sectionId ?? "") else { return }
                    if rawBinaryQuestions[identifier] == nil { rawBinaryQuestions.updateValue([:], forKey: identifier) }
                    rawBinaryQuestions[identifier]?.updateValue(selectedOption, forKey: option.optionId)
                }

                let miniMentalStateExamResults = MiniMentalStateExamModels.TestResults(questions: rawQuestions,
                                                                                       binaryQuestions: rawBinaryQuestions)

                let resultsTuple = resultsWorker?.getResults(for: .miniMentalStateExamination, results: miniMentalStateExamResults)
                if resultsTuple?.1 == .bad { isCognitiveDomainAltered = true }
            }

            if let verbalFluency = evaluation.verbalFluency, verbalFluency.isDone, !isCognitiveDomainAltered {
                let verbalFluencyResults = VerbalFluencyModels.TestResults(countedWords: verbalFluency.countedWords,
                                                                           selectedEducationOption: SelectableKeys(rawValue: verbalFluency.selectedOption) ?? .none)

                let resultsTuple = resultsWorker?.getResults(for: .verbalFluencyTest, results: verbalFluencyResults)
                if resultsTuple?.1 == .bad { isCognitiveDomainAltered = true }
            }

            if let clockDrawing = evaluation.clockDrawing, clockDrawing.isDone, !isCognitiveDomainAltered {
                var rawBinaryQuestions: ClockDrawingModels.RawBinaryQuestions = [:]

                guard let binaryOptions = clockDrawing.binaryOptions?.allObjects as? [BinaryOption] else {
                    return nil
                }

                binaryOptions.forEach { option in
                    guard let selectedOption = SelectableBinaryKeys(rawValue: option.selectedOption),
                          let identifier = LocalizedTable(rawValue: option.sectionId ?? "") else { return }
                    if rawBinaryQuestions[identifier] == nil { rawBinaryQuestions.updateValue([:], forKey: identifier) }
                    rawBinaryQuestions[identifier]?.updateValue(selectedOption, forKey: option.optionId)
                }

                let clockDrawingResults = ClockDrawingModels.TestResults(binaryQuestions: rawBinaryQuestions)

                let resultsTuple = resultsWorker?.getResults(for: .clockDrawingTest, results: clockDrawingResults)
                if resultsTuple?.1 == .bad { isCognitiveDomainAltered = true }
            }

            if let moCA = evaluation.moCA, moCA.isDone, !isCognitiveDomainAltered {
                var rawBinaryQuestions: MoCAModels.RawBinaryQuestions = [:]

                guard let binaryOptions = moCA.binaryOptions?.allObjects as? [BinaryOption] else {
                    return nil
                }

                binaryOptions.forEach { option in
                    guard let selectedOption = SelectableBinaryKeys(rawValue: option.selectedOption),
                          let identifier = LocalizedTable(rawValue: option.sectionId ?? "") else { return }
                    if rawBinaryQuestions[identifier] == nil { rawBinaryQuestions.updateValue([:], forKey: identifier) }
                    rawBinaryQuestions[identifier]?.updateValue(selectedOption, forKey: option.optionId)
                }

                let moCAResults = MoCAModels.TestResults(binaryQuestions: rawBinaryQuestions, selectedEducationOption: SelectableKeys(rawValue: moCA.selectedOption) ?? .none, countedWords: moCA.countedWords)

                let resultsTuple = resultsWorker?.getResults(for: .moca, results: moCAResults)
                if resultsTuple?.1 == .bad { isCognitiveDomainAltered = true }
            }

            if let geriatricDepressionScale = evaluation.miniMentalStateExam, geriatricDepressionScale.isDone, !isCognitiveDomainAltered {
                var rawQuestions: GeriatricDepressionScaleModels.RawQuestions = [:]

                guard let questionOptions = geriatricDepressionScale.selectableOptions?.allObjects as? [SelectableOption] else {
                    return nil
                }
                questionOptions.forEach { option in
                    guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                          let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                    rawQuestions[identifier] = selectedOption
                }

                let geriatricDepressionScaleResults = GeriatricDepressionScaleModels.TestResults(questions: rawQuestions)

                let resultsTuple = resultsWorker?.getResults(for: .geriatricDepressionScale, results: geriatricDepressionScaleResults)
                if resultsTuple?.1 == .bad { isCognitiveDomainAltered = true }
            }

            alteredDomains = isCognitiveDomainAltered ? alteredDomains + 1 : alteredDomains

            // MARK: - Sensory domain test results check

            return DashboardModels.TodoEvaluationViewModel(patientName: patientName, patientAge: birthDate.yearSinceCurrentDate,
                                                           alteredDomains: alteredDomains, nextApplicationDate: lastModification.addingMonth(1),
                                                           lastApplicationDate: lastModification, id: id)
        })
    }

}

// MARK: - Internal Delegate extensions

extension DashboardInteractor {
    func didTapComponent(identifier: DashboardModels.MenuOption) {
        switch identifier {
        case .patients:
            presenter?.route(toRoute: .patients)
        case .newCGA:
            presenter?.route(toRoute: .newCGA)
        case .reports:
            presenter?.route(toRoute: .reports)
        case .cgaDomains:
            presenter?.route(toRoute: .cgaDomains)
        default:
            return
        }
    }

    func didTapToReviewCGAs() {
        didSelect(menuOption: .cgas)
    }

    func didTapToSeeCGAExample() {
        didSelect(menuOption: .cgaDomains)
    }
}
