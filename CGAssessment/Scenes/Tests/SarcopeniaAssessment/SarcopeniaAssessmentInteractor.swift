//
//  SarcopeniaAssessmentInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 28/09/23.
//

import Foundation
import OSLog

protocol SarcopeniaAssessmentLogic: ActionButtonDelegate {
    func controllerDidLoad()
    func didSelect(test: SingleDomainModels.Test)
}

class SarcopeniaAssessmentInteractor: SarcopeniaAssessmentLogic {

    // MARK: - Private Properties

    private var presenter: SarcopeniaAssessmentPresentationLogic?
    private var worker: SarcopeniaAssessmentWorker?
    private var resultsWorker: ResultsWorker?
    private var cgaId: UUID?
    private var gripStrengthResults: GripStrengthModels.TestResults?
    private var calfCircumferenceResults: CalfCircumferenceModels.TestResults?
    private var timedUpAndGoResults: TimedUpAndGoModels.TestResults?
    private var walkingSpeedResults: WalkingSpeedModels.TestResults?
    private var testsCompletionStatus: [SingleDomainModels.Test: SingleDomainModels.TestStatus] = [:]
    private var testsResults: [SingleDomainModels.Test: ResultsModels.ResultType] = [:]

    // MARK: - Init

    init(presenter: SarcopeniaAssessmentPresentationLogic, worker: SarcopeniaAssessmentWorker,
         resultsWorker: ResultsWorker = ResultsWorker(), cgaId: UUID?) {
        self.presenter = presenter
        self.worker = worker
        self.resultsWorker = resultsWorker
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

    func didSelect(test: SingleDomainModels.Test) {
        switch test {
        case .gripStrength:
            presenter?.route(toRoute: .gripStrength(cgaId: cgaId))
        case .calfCircumference:
            presenter?.route(toRoute: .calfCircumference(cgaId: cgaId))
        case .timedUpAndGo:
            presenter?.route(toRoute: .timedUpAndGo(cgaId: cgaId))
        case .walkingSpeed:
            presenter?.route(toRoute: .walkingSpeed(cgaId: cgaId))
        default:
            break
        }
    }

    // MARK: - Private Methods

    private func sendDataToPresenter() {
        presenter?.presentData(viewModel: createViewModel())
    }

    private func createViewModel() -> SarcopeniaAssessmentModels.ControllerViewModel {
        return SarcopeniaAssessmentModels.ControllerViewModel(testsCompletionStatus: testsCompletionStatus, testsResults: testsResults)
    }

    private func handleNavigation(updatesDatabase: Bool = false) {
        guard let gripStrengthResults else { return }

        if updatesDatabase {
            updateDatabase(isDone: true)
        }

        presenter?.route(toRoute: .testResults(test: .sarcopeniaAssessment, results: .init(gripStrengthResults: gripStrengthResults,
                                                                                           calfCircumferenceResults: calfCircumferenceResults,
                                                                                           timedUpAndGoResults: timedUpAndGoResults,
                                                                                           walkingSpeedResults: walkingSpeedResults), cgaId: cgaId))
    }

    private func computeViewModelData() {
        getTestsProgress()
        getTestsResults()
    }

    private func getTestsProgress() {
        if let gripStrengthProgress = try? worker?.getGripStrengthProgress() {
            testsCompletionStatus.updateValue(gripStrengthProgress.isDone ? .done : .incomplete,
                                              forKey: .gripStrength)

            if let firstMeasurement = gripStrengthProgress.firstMeasurement as? Double,
               let secondMeasurement = gripStrengthProgress.secondMeasurement as? Double,
               let thirdMeasurement = gripStrengthProgress.thirdMeasurement as? Double,
               let gender = try? worker?.getPatientGender(), gripStrengthProgress.isDone {
                gripStrengthResults = .init(firstMeasurement: firstMeasurement, secondMeasurement: secondMeasurement,
                                            thirdMeasurement: thirdMeasurement, gender: gender)
            }
        } else {
            testsCompletionStatus.updateValue(.notStarted, forKey: .gripStrength)
        }

        if let calfCircumferenceProgress = try? worker?.getCalfCircumferenceProgress() {
            testsCompletionStatus.updateValue(calfCircumferenceProgress.isDone ? .done : .incomplete,
                                              forKey: .calfCircumference)

            if let circumference = calfCircumferenceProgress.measuredCircumference as? Double,
               calfCircumferenceProgress.isDone {
                calfCircumferenceResults = .init(circumference: circumference)
            }
        } else {
            testsCompletionStatus.updateValue(.notStarted, forKey: .calfCircumference)
        }

        if let timedUpAndGoProgress = try? worker?.getTimedUpAndGoProgress() {
            testsCompletionStatus.updateValue(timedUpAndGoProgress.isDone ? .done : .incomplete,
                                              forKey: .timedUpAndGo)

            if timedUpAndGoProgress.hasStopwatch {
                if let elapsedTime = timedUpAndGoProgress.typedTime as? Double,
                   timedUpAndGoProgress.isDone {
                    timedUpAndGoResults = .init(elapsedTime: elapsedTime)
                }
            } else {
                if let elapsedTime = timedUpAndGoProgress.measuredTime as? Double,
                   timedUpAndGoProgress.isDone {
                    timedUpAndGoResults = .init(elapsedTime: elapsedTime)
                }
            }
        } else {
            testsCompletionStatus.updateValue(.notStarted, forKey: .timedUpAndGo)
        }

        if let walkingSpeedProgress = try? worker?.getWalkingSpeedProgress() {
            testsCompletionStatus.updateValue(walkingSpeedProgress.isDone ? .done : .incomplete,
                                              forKey: .walkingSpeed)

            if walkingSpeedProgress.hasStopwatch {
                if let firstElapsedTime = walkingSpeedProgress.firstTypedTime as? Double,
                   let secondElapsedTime = walkingSpeedProgress.secondTypedTime as? Double,
                   let thirdElapsedTime = walkingSpeedProgress.thirdTypedTime as? Double,
                   walkingSpeedProgress.isDone {
                    walkingSpeedResults = .init(firstElapsedTime: firstElapsedTime,
                                                secondElapsedTime: secondElapsedTime,
                                                thirdElapsedTime: thirdElapsedTime)
                }
            } else {
                if let firstElapsedTime = walkingSpeedProgress.firstMeasuredTime as? Double,
                   let secondElapsedTime = walkingSpeedProgress.secondMeasuredTime as? Double,
                   let thirdElapsedTime = walkingSpeedProgress.thirdMeasuredTime as? Double,
                   walkingSpeedProgress.isDone {
                    walkingSpeedResults = .init(firstElapsedTime: firstElapsedTime,
                                                secondElapsedTime: secondElapsedTime,
                                                thirdElapsedTime: thirdElapsedTime)
                }
            }
        } else {
            testsCompletionStatus.updateValue(.notStarted, forKey: .walkingSpeed)
        }

        if let sarcopeniaAssessmentProgress = try? worker?.getSarcopeniaAssessmentProgress() {
            if sarcopeniaAssessmentProgress.isDone {
                handleNavigation()
            }
        }
    }

    private func getTestsResults() {
        if let gripStrengthResults, let resultType = resultsWorker?.getResults(for: .gripStrength, results: gripStrengthResults) {
            testsResults.updateValue(resultType.1, forKey: .gripStrength)
        }

        if let calfCircumferenceResults, let resultType = resultsWorker?.getResults(for: .calfCircumference, results: calfCircumferenceResults) {
            testsResults.updateValue(resultType.1, forKey: .calfCircumference)
        }

        if let timedUpAndGoResults, let resultType = resultsWorker?.getResults(for: .timedUpAndGo, results: timedUpAndGoResults) {
            testsResults.updateValue(resultType.1, forKey: .timedUpAndGo)
        }

        if let walkingSpeedResults, let resultType = resultsWorker?.getResults(for: .walkingSpeed, results: walkingSpeedResults) {
            testsResults.updateValue(resultType.1, forKey: .walkingSpeed)
        }
    }

    private func updateDatabase(isDone: Bool = false) {
        do {
            try worker?.updateSarcopeniaAssessmentProgress(with: .init(isDone: isDone))
        } catch {
            os_log("Error: %@", log: .default, type: .error, String(describing: error))
        }
    }
}
