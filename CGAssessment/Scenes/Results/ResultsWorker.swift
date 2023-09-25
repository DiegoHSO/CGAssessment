//
//  ResultsWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation

class ResultsWorker {

    // MARK: - Public Methods

    // swiftlint:disable:next cyclomatic_complexity
    func getResults(for test: SingleDomainModels.Test, results: Any?) -> ([ResultsModels.Result], ResultsModels.ResultType)? {
        switch test {
        case .timedUpAndGo:
            guard let timedUpAndGoResults = results as? TimedUpAndGoModels.TestResults else { return nil }
            return getTimedUpAndGoResults(for: timedUpAndGoResults)
        case .walkingSpeed:
            guard let walkingSpeedResults = results as? WalkingSpeedModels.TestResults else { return nil }
            return getWalkingSpeedResults(for: walkingSpeedResults)
        case .calfCircumference:
            break
        case .gripStrength:
            break
        case .sarcopeniaAssessment:
            break
        case .miniMentalStateExamination:
            break
        case .verbalFluencyTest:
            break
        case .clockDrawingTest:
            break
        case .moca:
            break
        case .geriatricDepressionScale:
            break
        case .visualAcuityAssessment:
            break
        case .hearingLossAssessment:
            break
        case .katzScale:
            break
        case .lawtonScale:
            break
        case .miniNutritionalAssessment:
            break
        case .apgarScale:
            break
        case .zaritScale:
            break
        case .polypharmacyCriteria:
            break
        case .charlsonIndex:
            break
        case .suspectedAbuse:
            break
        case .cardiovascularRiskEstimation:
            break
        case .chemotherapyToxicityRisk:
            break
        }

        return nil
    }

    // MARK: - Private Methods

    private func getTimedUpAndGoResults(for testResults: TimedUpAndGoModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        var results: [ResultsModels.Result] = [.init(title: LocalizedTable.measuredTime.localized,
                                                     description: "\(testResults.elapsedTime.formatted) \(LocalizedTable.seconds.localized)")]
        let resultType: ResultsModels.ResultType

        if testResults.elapsedTime < 10 {
            resultType = .excellent
            results.append(.init(title: LocalizedTable.suggestedDiagnosis.localized,
                                 description: LocalizedTable.timedUpAndGoExcellentResult.localized))
        } else if testResults.elapsedTime >= 10 && testResults.elapsedTime < 20 {
            resultType = .good
            results.append(.init(title: LocalizedTable.suggestedDiagnosis.localized,
                                 description: LocalizedTable.timedUpAndGoGoodResult.localized))
        } else if testResults.elapsedTime >= 20 && testResults.elapsedTime < 30 {
            resultType = .medium
            results.append(.init(title: LocalizedTable.suggestedDiagnosis.localized,
                                 description: LocalizedTable.timedUpAndGoMediumResult.localized))
        } else {
            resultType = .bad
            results.append(.init(title: LocalizedTable.suggestedDiagnosis.localized,
                                 description: LocalizedTable.timedUpAndGoBadResult.localized))
        }

        return (results, resultType)
    }

    private func getWalkingSpeedResults(for testResults: WalkingSpeedModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        // swiftlint:disable line_length
        let firstDescription = "\(LocalizedTable.first.localized) \(LocalizedTable.measurement.localized): \(testResults.firstElapsedTime.formatted) \(LocalizedTable.seconds.localized)\n"
        let secondDescription = "\(LocalizedTable.second.localized) \(LocalizedTable.measurement.localized): \(testResults.secondElapsedTime.formatted) \(LocalizedTable.seconds.localized)\n"
        let thirdDescription = "\(LocalizedTable.third.localized) \(LocalizedTable.measurement.localized): \(testResults.thirdElapsedTime.formatted) \(LocalizedTable.seconds.localized)"
        // swiftlint:enable line_length

        var results: [ResultsModels.Result] = [.init(title: LocalizedTable.measuredTime.localized,
                                                     description: firstDescription + secondDescription + thirdDescription)]

        let attempts = [testResults.firstElapsedTime, testResults.secondElapsedTime, testResults.thirdElapsedTime]
        let average = attempts.reduce(0.0, +) / Double(attempts.count)
        let speed = 4 / average

        let resultType: ResultsModels.ResultType = speed >= 0.8 ? .excellent : .bad

        let speedDescription: String

        if speed <= 1 {
            speedDescription = LocalizedTable.meterPerSecond.localized
        } else {
            speedDescription = LocalizedTable.metersPerSecond.localized
        }

        results.append(.init(title: LocalizedTable.averageSpeed.localized,
                             description: "\(speed.regionFormatted(fractionDigits: 2)) \(speedDescription)"))
        results.append(.init(title: LocalizedTable.suggestedDiagnosis.localized,
                             description: resultType == .excellent ? LocalizedTable.walkingSpeedExcellentResult.localized
                                : LocalizedTable.walkingSpeedBadResult.localized))

        return (results, resultType)
    }
}
