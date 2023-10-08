//
//  PatientsInteractor.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 03/10/23.
//

import Foundation

protocol PatientsLogic: FilterDelegate, SearchBarDelegate {
    func controllerDidLoad()
    func didSelect(patientId: UUID?)
    func didTapToStartNewCGA()
}

class PatientsInteractor: PatientsLogic {

    // MARK: - Private Properties

    private var presenter: PatientsPresentationLogic?
    private var worker: PatientsWorker?
    private var resultsWorker: ResultsWorker?
    private var selectedFilter: CGAModels.FilterOptions = .aToZ
    private var viewModels: [PatientsModels.PatientViewModel] = []
    private var searchText: String = ""
    private var filteredPatients: [PatientsModels.PatientViewModel] {
        if !searchText.isEmpty {
            return viewModels.filter { $0.name.containsCaseInsensitive(searchText)}
        }

        return viewModels
    }

    // MARK: - Init

    init(presenter: PatientsPresentationLogic, worker: PatientsWorker, resultsWorker: ResultsWorker = ResultsWorker()) {
        self.presenter = presenter
        self.worker = worker
        self.resultsWorker = resultsWorker
    }

    // MARK: - Public Methods

    func controllerDidLoad() {
        computeViewModelData()
        sendDataToPresenter()
    }

    func didSelect(patientId: UUID?) {
        presenter?.route(toRoute: .cgas(patientId: patientId))
    }

    func didSelect(filterOption: CGAModels.FilterOptions) {
        selectedFilter = filterOption
        computeViewModelData()
        sendDataToPresenter()
    }

    func didTapToStartNewCGA() {
        presenter?.route(toRoute: .newCGA)
    }

    func didChange(searchText: String) {
        self.searchText = searchText
        sendDataToPresenter(isSearching: true)
    }

    // MARK: - Private Methods

    private func computeViewModelData() {
        guard var patients = try? worker?.getPatients() else { return }
        patients = patients.filter { $0.patientId != nil }

        viewModels = patients.compactMap { patient in
            var patientCGAs = patient.cgas?.allObjects as? [CGA]
            patientCGAs?.sort(by: { ($0.lastModification ?? Date()) > ($1.lastModification ?? Date()) })

            let lastCGA = patientCGAs?.first

            let hasCGAInProgress: Bool
            if let lastModification = lastCGA?.lastModification,
               lastModification.timeIntervalSince(Date()) > .week {
                hasCGAInProgress = false
            } else {
                hasCGAInProgress = true
            }

            let gender = Gender(rawValue: patient.gender) ?? .female
            var alteredDomains = 0

            // MARK: - Mobility domains test results check

            var isMobilityDomainAltered: Bool = false
            var timedUpAndGoResults: TimedUpAndGoModels.TestResults?
            var walkingSpeedResults: WalkingSpeedModels.TestResults?
            var calfCircumferenceResults: CalfCircumferenceModels.TestResults?
            var gripStrengthResults: GripStrengthModels.TestResults?

            if let timedUpAndGo = lastCGA?.timedUpAndGo, timedUpAndGo.isDone {
                timedUpAndGoResults = TimedUpAndGoModels.TestResults(elapsedTime: timedUpAndGo.hasStopwatch ?
                                                                        timedUpAndGo.typedTime as? Double ?? 0 :
                                                                        timedUpAndGo.measuredTime as? Double ?? 0)

                let resultsTuple = resultsWorker?.getResults(for: .timedUpAndGo, results: timedUpAndGoResults)
                if resultsTuple?.1 == .bad || resultsTuple?.1 == .medium { isMobilityDomainAltered = true }
            }

            if let walkingSpeed = lastCGA?.walkingSpeed, walkingSpeed.isDone, !isMobilityDomainAltered {
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

            if let calfCircumference = lastCGA?.calfCircumference, calfCircumference.isDone, !isMobilityDomainAltered {
                calfCircumferenceResults = CalfCircumferenceModels.TestResults(circumference: calfCircumference.measuredCircumference as? Double ?? 0)

                let resultsTuple = resultsWorker?.getResults(for: .calfCircumference, results: calfCircumferenceResults)
                if resultsTuple?.1 == .bad { isMobilityDomainAltered = true }
            }

            if let gripStrength = lastCGA?.gripStrength, gripStrength.isDone, !isMobilityDomainAltered {
                gripStrengthResults = GripStrengthModels.TestResults(firstMeasurement: gripStrength.firstMeasurement as? Double ?? 0,
                                                                     secondMeasurement: gripStrength.secondMeasurement as? Double ?? 0,
                                                                     thirdMeasurement: gripStrength.thirdMeasurement as? Double ?? 0,
                                                                     gender: gender)

                let resultsTuple = resultsWorker?.getResults(for: .gripStrength, results: gripStrengthResults)
                if resultsTuple?.1 == .bad { isMobilityDomainAltered = true }
            }

            if let sarcopeniaAssessment = lastCGA?.sarcopeniaAssessment, sarcopeniaAssessment.isDone, !isMobilityDomainAltered,
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

            if let miniMentalStateExamProgress = lastCGA?.miniMentalStateExam, miniMentalStateExamProgress.isDone {
                var rawQuestions: MiniMentalStateExamModels.RawQuestions = [:]
                var rawBinaryQuestions: MiniMentalStateExamModels.RawBinaryQuestions = [:]

                guard let binaryOptions = miniMentalStateExamProgress.binaryOptions?.allObjects as? [BinaryOption],
                      let questionOptions = miniMentalStateExamProgress.selectableOptions?.allObjects as? [SelectableOption] else {
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

            if let verbalFluency = lastCGA?.verbalFluency, verbalFluency.isDone, !isCognitiveDomainAltered {
                let verbalFluencyResults = VerbalFluencyModels.TestResults(countedWords: verbalFluency.countedWords,
                                                                           selectedEducationOption: SelectableKeys(rawValue: verbalFluency.selectedOption) ?? .none)

                let resultsTuple = resultsWorker?.getResults(for: .verbalFluencyTest, results: verbalFluencyResults)
                if resultsTuple?.1 == .bad { isCognitiveDomainAltered = true }
            }

            if let clockDrawing = lastCGA?.clockDrawing, clockDrawing.isDone, !isCognitiveDomainAltered {
                var rawBinaryQuestions: MiniMentalStateExamModels.RawBinaryQuestions = [:]

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

            alteredDomains = isCognitiveDomainAltered ? alteredDomains + 1 : alteredDomains

            return .init(name: patient.name ?? "", birthDate: patient.birthDate ?? Date(), hasCGAInProgress: hasCGAInProgress,
                         lastCGADate: lastCGA?.lastModification, alteredDomains: alteredDomains, gender: gender, patientId: patient.patientId)
        }

        switch selectedFilter {
        case .aToZ:
            viewModels.sort(by: { $0.name < $1.name })
        case .zToA:
            viewModels.sort(by: { $0.name > $1.name })
        case .olderAge:
            viewModels.sort(by: { $0.birthDate.yearSinceCurrentDate > $1.birthDate.yearSinceCurrentDate })
        case .youngerAge:
            viewModels.sort(by: { $0.birthDate.yearSinceCurrentDate < $1.birthDate.yearSinceCurrentDate })
        default:
            return
        }
    }

    private func sendDataToPresenter(isSearching: Bool = false) {
        presenter?.presentData(viewModel: .init(patients: filteredPatients,
                                                filterOptions: [.aToZ, .zToA, .olderAge, .youngerAge],
                                                selectedFilter: selectedFilter, isSearching: isSearching))
    }
}
