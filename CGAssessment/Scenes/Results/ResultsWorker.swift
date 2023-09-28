//
//  ResultsWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation

class ResultsWorker {

    // MARK: - Public Methods

    func getResults(for test: SingleDomainModels.Test, results: Any?) -> ([ResultsModels.Result], ResultsModels.ResultType)? {
        switch test {
        case .timedUpAndGo:
            guard let timedUpAndGoResults = results as? TimedUpAndGoModels.TestResults else { return nil }
            return getTimedUpAndGoResults(for: timedUpAndGoResults)
        case .walkingSpeed:
            guard let walkingSpeedResults = results as? WalkingSpeedModels.TestResults else { return nil }
            return getWalkingSpeedResults(for: walkingSpeedResults)
        case .calfCircumference:
            guard let calfCircumferenceResults = results as? CalfCircumferenceModels.TestResults else { return nil }
            return getCalfCircumferenceResults(for: calfCircumferenceResults)
        case .gripStrength:
            guard let gripStrengthResults = results as? GripStrengthModels.TestResults else { return nil }
            return getGripStrengthResults(for: gripStrengthResults)
        case .sarcopeniaAssessment:
            if let sarcopeniaScreeningResults = results as? SarcopeniaScreeningModels.ScreeningTestResults {
                return getSarcopeniaScreeningResults(for: sarcopeniaScreeningResults)
            } else {
                return getSarcopeniaAssessmentResults()
            }
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
                                                     description: "\(testResults.elapsedTime.regionFormatted()) \(LocalizedTable.seconds.localized)")]
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
        let firstDescription = "\(LocalizedTable.first.localized) \(LocalizedTable.measurement.localized): \(testResults.firstElapsedTime.regionFormatted()) \(LocalizedTable.seconds.localized)\n"
        let secondDescription = "\(LocalizedTable.second.localized) \(LocalizedTable.measurement.localized): \(testResults.secondElapsedTime.regionFormatted()) \(LocalizedTable.seconds.localized)\n"
        let thirdDescription = "\(LocalizedTable.third.localized) \(LocalizedTable.measurement.localized): \(testResults.thirdElapsedTime.regionFormatted()) \(LocalizedTable.seconds.localized)"

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

    private func getCalfCircumferenceResults(for testResults: CalfCircumferenceModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        var results: [ResultsModels.Result] = [.init(title: LocalizedTable.measuredValue.localized,
                                                     description: "\(testResults.circumference.regionFormatted()) \(LocalizedTable.centimeters.localized)")]

        let resultType: ResultsModels.ResultType

        if testResults.circumference >= 31 {
            resultType = .excellent
            results.append(.init(title: LocalizedTable.suggestedDiagnosis.localized,
                                 description: LocalizedTable.calfCircumferenceExcellentResult.localized))
        } else {
            resultType = .bad
            results.append(.init(title: LocalizedTable.suggestedDiagnosis.localized,
                                 description: LocalizedTable.calfCircumferenceBadResult.localized))
        }

        return (results, resultType)
    }

    private func getGripStrengthResults(for testResults: GripStrengthModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        let firstDescription = "\(LocalizedTable.first.localized) \(LocalizedTable.measurement.localized): \(testResults.firstMeasurement.regionFormatted()) kgf\n"
        let secondDescription = "\(LocalizedTable.second.localized) \(LocalizedTable.measurement.localized): \(testResults.secondMeasurement.regionFormatted()) kgf\n"
        let thirdDescription = "\(LocalizedTable.third.localized) \(LocalizedTable.measurement.localized): \(testResults.thirdMeasurement.regionFormatted()) kgf"

        var results: [ResultsModels.Result] = [.init(title: LocalizedTable.measuredStrength.localized,
                                                     description: firstDescription + secondDescription + thirdDescription)]

        let attempts = [testResults.firstMeasurement, testResults.secondMeasurement, testResults.thirdMeasurement]
        let average = attempts.reduce(0.0, +) / Double(attempts.count)

        results.append(.init(title: LocalizedTable.averageStrength.localized,
                             description: "\(average.regionFormatted()) kgf"))

        let resultType: ResultsModels.ResultType

        switch testResults.gender {
        case .female:
            resultType = average >= 16 ? .excellent : .bad
        case .male:
            resultType = average >= 27 ? .excellent : .bad
        }

        results.append(.init(title: LocalizedTable.suggestedDiagnosis.localized,
                             description: resultType == .excellent ? LocalizedTable.gripStrengthExcellentResult.localized :
                                LocalizedTable.gripStrengthBadResult.localized))

        return (results, resultType)
    }

    private func getSarcopeniaScreeningResults(for testResults: SarcopeniaScreeningModels.ScreeningTestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {

        let selectedOptions = [testResults.firstQuestionOption, testResults.secondQuestionOption, testResults.thirdQuestionOption,
                               testResults.fourthQuestionOption, testResults.fifthQuestionOption]

        var score = selectedOptions.reduce(0) { partialResult, option in
            switch option {
            case .secondOption:
                return partialResult + 1
            case .thirdOption:
                return partialResult + 2
            default:
                return partialResult
            }
        }

        let customScore: Int

        switch testResults.gender {
        case .female:
            customScore = testResults.sixthQuestionOption == .firstOption ? 0 : 10
        case .male:
            customScore = testResults.sixthQuestionOption == .firstOption ? 0 : 10
        }

        score += customScore

        let resultType: ResultsModels.ResultType = score < 11 ? .excellent : .bad

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.totalScore.localized,
                                                     description: "\(score) \(score == 1 ? LocalizedTable.point.localized : LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultType == .excellent ?
                                                        LocalizedTable.sarcopeniaScreeningExcellentResult.localized
                                                        : LocalizedTable.sarcopeniaScreeningBadResult.localized)]

        return (results, resultType)
    }

    // TODO: Apply Core Data logic
    private func getSarcopeniaAssessmentResults() -> ([ResultsModels.Result], ResultsModels.ResultType) {
        return ([.init(title: "", description: "")], .excellent)
    }
}
