//
//  ResultsWorker.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 24/09/23.
//

import Foundation

class ResultsWorker {

    // MARK: - Private Properties

    private let cgaId: UUID?
    private let dao: CoreDataDAOProtocol?

    // MARK: - Init

    init(dao: CoreDataDAOProtocol? = nil, cgaId: UUID? = nil) {
        self.cgaId = cgaId
        self.dao = dao
    }

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
        case .sarcopeniaScreening:
            guard let sarcopeniaScreeningResults = results as? SarcopeniaScreeningModels.TestResults else { return nil }
            return getSarcopeniaScreeningResults(for: sarcopeniaScreeningResults)
        case .sarcopeniaAssessment:
            guard let sarcopeniaAssessmentResults = results as? SarcopeniaAssessmentModels.TestResults else { return nil }
            return getSarcopeniaAssessmentResults(for: sarcopeniaAssessmentResults)
        case .miniMentalStateExamination:
            guard let miniMentalStateExamResults = results as? MiniMentalStateExamModels.TestResults else { return nil }
            return getMiniMentalStateExamResults(for: miniMentalStateExamResults)
        case .verbalFluencyTest:
            guard let verbalFluencyTestResults = results as? VerbalFluencyModels.TestResults else { return nil }
            return getVerbalFluencyResults(for: verbalFluencyTestResults)
        case .clockDrawingTest:
            guard let clockDrawingTestResults = results as? ClockDrawingModels.TestResults else { return nil }
            return getClockDrawingResults(for: clockDrawingTestResults)
        case .moca:
            guard let mocaResults = results as? MoCAModels.TestResults else { return nil }
            return getMoCAResults(for: mocaResults)
        case .geriatricDepressionScale:
            guard let geriatricDepressionScaleResults = results as? GeriatricDepressionScaleModels.TestResults else { return nil }
            return getGeriatricDepressionScaleResults(for: geriatricDepressionScaleResults)
        case .visualAcuityAssessment:
            guard let visualAcuityAssessmentResults = results as? VisualAcuityAssessmentModels.TestResults else { return nil }
            return getVisualAcuityAssessmentResults(for: visualAcuityAssessmentResults)
        case .katzScale:
            guard let katzScaleResults = results as? KatzScaleModels.TestResults else { return nil }
            return getKatzScaleResults(for: katzScaleResults)
        case .lawtonScale:
            guard let lawtonScaleResults = results as? LawtonScaleModels.TestResults else { return nil }
            return getLawtonScaleResults(for: lawtonScaleResults)
        case .miniNutritionalAssessment:
            guard let miniNutritionalAssessmentResults = results as? MiniNutritionalAssessmentModels.TestResults else { return nil }
            return getMiniNutritionalAsessmentResults(for: miniNutritionalAssessmentResults)
        case .apgarScale:
            guard let apgarScaleResults = results as? ApgarScaleModels.TestResults else { return nil }
            return getApgarScaleResults(for: apgarScaleResults)
        case .zaritScale:
            guard let zaritScaleResults = results as? ZaritScaleModels.TestResults else { return nil }
            return getZaritScaleResults(for: zaritScaleResults)
        case .polypharmacyCriteria:
            guard let polypharmacyCriteriaResults = results as? PolypharmacyCriteriaModels.TestResults else { return nil }
            return getPolypharmacyCriteriaResults(for: polypharmacyCriteriaResults)
        case .charlsonIndex:
            guard let charlsonIndexResults = results as? CharlsonIndexModels.TestResults else { return nil }
            return getCharlsonIndexResults(for: charlsonIndexResults)
        case .chemotherapyToxicityRisk:
            guard let chemotherapyToxicityRiskResults = results as? ChemotherapyToxicityRiskModels.TestResults else { return nil }
            return getChemotherapyToxicityRiskResults(for: chemotherapyToxicityRiskResults)
        default:
            break
        }

        return nil
    }

    func updateSarcopeniaAssessmentProgress(with data: SarcopeniaAssessmentModels.TestData) throws {
        guard let cgaId, let dao else {
            throw CoreDataErrors.unableToUpdateCGA
        }

        try dao.updateCGA(with: data, cgaId: cgaId)
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

    private func getSarcopeniaScreeningResults(for testResults: SarcopeniaScreeningModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {

        let selectedOptions = testResults.questions.values.map { $0 as SelectableKeys }

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

        customScore = testResults.questions[.sarcopeniaAssessmentSixthQuestion] == .firstOption ? 0 : 10

        score += customScore

        let resultType: ResultsModels.ResultType = score < 11 ? .excellent : .bad

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.totalScore.localized,
                                                     description: "\(score) \(score == 1 ? LocalizedTable.point.localized : LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultType == .excellent ?
                                                        LocalizedTable.sarcopeniaScreeningExcellentResult.localized
                                                        : LocalizedTable.sarcopeniaScreeningBadResult.localized)]

        return (results, resultType)
    }

    private func getSarcopeniaAssessmentResults(for testResults: SarcopeniaAssessmentModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        let (_, gripStrengthResult) = getGripStrengthResults(for: testResults.gripStrengthResults)

        if gripStrengthResult == .excellent {
            return ([.init(title: LocalizedTable.affectedCategories.localized, description: LocalizedTable.noneGenderFlexion.localized),
                     .init(title: LocalizedTable.suggestedDiagnosis.localized, description: LocalizedTable.sarcopeniaAssessmentExcellentResult.localized)], .excellent)
        }

        if let calfCircumferenceResults = testResults.calfCircumferenceResults {
            let (_, calfCircumferenceResult) = getCalfCircumferenceResults(for: calfCircumferenceResults)

            if calfCircumferenceResult == .excellent {
                return ([.init(title: LocalizedTable.affectedCategories.localized, description: LocalizedTable.muscleStrength.localized),
                         .init(title: LocalizedTable.suggestedDiagnosis.localized, description: LocalizedTable.sarcopeniaAssessmentGoodResult.localized)], .medium)
            }

            var musclePerformanceResult: ResultsModels.ResultType?

            if let timedUpAndGoResults = testResults.timedUpAndGoResults {
                let (_, timedUpAndGoResult) = getTimedUpAndGoResults(for: timedUpAndGoResults)

                musclePerformanceResult = timedUpAndGoResult
            }

            if let walkingSpeedResults = testResults.walkingSpeedResults {
                let (_, walkingSpeedResult) = getWalkingSpeedResults(for: walkingSpeedResults)

                musclePerformanceResult = musclePerformanceResult == .bad || musclePerformanceResult == nil ? walkingSpeedResult : musclePerformanceResult
            }

            if musclePerformanceResult == .excellent || musclePerformanceResult == .good {
                return ([.init(title: LocalizedTable.affectedCategories.localized,
                               description: "\(LocalizedTable.muscleStrength.localized) \(LocalizedTable.and.localized) \(LocalizedTable.muscleAmount.localized)"),
                         .init(title: LocalizedTable.suggestedDiagnosis.localized, description: LocalizedTable.sarcopeniaAssessmentMediumResult.localized)], .medium)
            } else {
                return ([.init(title: LocalizedTable.affectedCategories.localized,
                               description: "\(LocalizedTable.muscleStrength.localized), \(LocalizedTable.muscleAmount.localized) \(LocalizedTable.and.localized) \(LocalizedTable.musclePerformance.localized)"),
                         .init(title: LocalizedTable.suggestedDiagnosis.localized, description: LocalizedTable.sarcopeniaAssessmentBadResult.localized)], .bad)
            }
        }

        return ([], .excellent)
    }

    private func getMiniMentalStateExamResults(for testResults: MiniMentalStateExamModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        let selectedOptions = testResults.questions.filter({ $0.key != .miniMentalStateExamFirstQuestion }).values.map { $0 as SelectableKeys }
        let binaryOptionsDictionaries = testResults.binaryQuestions.map { $0.value }
        let selectedBinaryOptions = binaryOptionsDictionaries.reduce([]) { partialResult, dictionary in
            partialResult + dictionary.map { $0.value }
        }

        let selectedOptionsPointed = selectedOptions.filter { $0 == .firstOption }
        let selectedOptionsPoints = selectedOptionsPointed.map { $0.rawValue }.reduce(0, +)

        let selectedBinaryOptionsPointed = selectedBinaryOptions.filter { $0 == .yes }
        let selectedBinaryOptionsPoints = selectedBinaryOptionsPointed.map { $0.rawValue }.reduce(0, +)

        let totalPoints = selectedOptionsPoints + selectedBinaryOptionsPoints

        let resultType: ResultsModels.ResultType = switch testResults.questions[.miniMentalStateExamFirstQuestion] {
        case .firstOption: // More than eleven years of study
            totalPoints >= 29 ? .excellent : .bad
        case .secondOption: // Between nine and eleven years of study
            totalPoints >= 28 ? .excellent : .bad
        case .thirdOption: // Between five and eight years of study
            totalPoints >= 26 ? .excellent : .bad
        case .fourthOption: // Between one and four years of study
            totalPoints >= 25 ? .excellent : .bad
        case .fifthOption: // Illiterate
            totalPoints >= 20 ? .excellent : .bad
        default:
            .bad
        }

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.totalScore.localized,
                                                     description: "\(totalPoints) \(totalPoints == 1 ? LocalizedTable.point.localized : LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultType == .excellent ?
                                                        LocalizedTable.miniMentalStateExamExcellentResult.localized
                                                        : LocalizedTable.miniMentalStateExamBadResult.localized)]

        return (results, resultType)
    }

    private func getVerbalFluencyResults(for testResults: VerbalFluencyModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {

        let resultType: ResultsModels.ResultType = switch testResults.selectedEducationOption {
        case .firstOption: // Eight or more years of education
            testResults.countedWords >= 13 ? .excellent : .bad
        case .secondOption: // Less than eight years of education
            testResults.countedWords >= 9 ? .excellent : .bad
        default:
            .bad
        }

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.numberOfWords.localized,
                                                     description: "\(testResults.countedWords) \(testResults.countedWords == 1 ? LocalizedTable.word.localized : LocalizedTable.words.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultType == .excellent ?
                                                        LocalizedTable.verbalFluencyExcellentResult.localized
                                                        : LocalizedTable.verbalFluencyBadResult.localized)]

        return (results, resultType)
    }

    private func getClockDrawingResults(for testResults: ClockDrawingModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        let binaryOptionsDictionaries = testResults.binaryQuestions.map { $0.value }
        let selectedBinaryOptions = binaryOptionsDictionaries.reduce([]) { partialResult, dictionary in
            partialResult + dictionary.map { $0.value }
        }

        let selectedBinaryOptionsPointed = selectedBinaryOptions.filter { $0 == .yes }
        let totalPoints = selectedBinaryOptionsPointed.map { $0.rawValue }.reduce(0, +)

        let resultType: ResultsModels.ResultType = totalPoints < 11 ? .bad : .excellent

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.totalScore.localized,
                                                     description: "\(totalPoints) \(totalPoints == 1 ? LocalizedTable.point.localized : LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultType == .excellent ?
                                                        LocalizedTable.clockDrawingExcellentResult.localized
                                                        : LocalizedTable.clockDrawingBadResult.localized)]

        return (results, resultType)
    }

    private func getMoCAResults(for testResults: MoCAModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        var totalPoints: Int16 = 0

        let visuospatialResults = testResults.binaryQuestions[.visuospatial]?.map { $0.value } ?? []
        let visuospatialResultsPointed = visuospatialResults.filter { $0 == .yes }
        let visuospatialTotalPoints = visuospatialResultsPointed.map { $0.rawValue }.reduce(0, +)
        totalPoints += visuospatialTotalPoints

        let namingResults = testResults.binaryQuestions[.naming]?.map { $0.value } ?? []
        let namingResultsPointed = namingResults.filter { $0 == .yes }
        let namingTotalPoints = namingResultsPointed.map { $0.rawValue }.reduce(0, +)
        totalPoints += namingTotalPoints

        let calculationResults = (testResults.binaryQuestions[.mocaFourthSectionFourthInstruction]?.map { $0.value } ?? [])
        let calculationResultsPointed = calculationResults.filter { $0 == .yes }
        let calculationTotalPoints = calculationResultsPointed.map { $0.rawValue }.reduce(0, +)
        let adjustedCalculationTotalPoints = calculationTotalPoints >= 4 ? 3 : calculationTotalPoints >= 2 ? 2 : calculationTotalPoints

        let attentionResults = (testResults.binaryQuestions[.mocaFourthSectionSecondInstruction]?.map { $0.value } ?? []) +
            (testResults.binaryQuestions[.mocaFourthSectionThirdInstruction]?.map { $0.value } ?? [])
        let attentionResultsPointed = attentionResults.filter { $0 == .yes }
        let attentionTotalPoints = adjustedCalculationTotalPoints + attentionResultsPointed.map { $0.rawValue }.reduce(0, +)
        totalPoints += attentionTotalPoints

        let languageResults = testResults.binaryQuestions[.language]?.map { $0.value } ?? []
        let languageResultsPointed = languageResults.filter { $0 == .yes }
        let totalWordsPoints: Int16 = testResults.countedWords >= 11 ? 1 : 0
        let languageTotalPoints = totalWordsPoints + languageResultsPointed.map { $0.rawValue }.reduce(0, +)
        totalPoints += languageTotalPoints

        let abstractionResults = testResults.binaryQuestions[.abstraction]?.map { $0.value } ?? []
        let abstractionResultsPointed = abstractionResults.filter { $0 == .yes }
        let abstractionTotalPoints = abstractionResultsPointed.map { $0.rawValue }.reduce(0, +)
        totalPoints += abstractionTotalPoints

        let delayedRecallResults = testResults.binaryQuestions[.delayedRecall]?.map { $0.value } ?? []
        let delayedRecallResultsPointed = delayedRecallResults.filter { $0 == .yes }
        let delayedRecallTotalPoints = delayedRecallResultsPointed.map { $0.rawValue }.reduce(0, +)
        totalPoints += delayedRecallTotalPoints

        let orientationResults = testResults.binaryQuestions[.orientation]?.map { $0.value } ?? []
        let orientationResultsPointed = orientationResults.filter { $0 == .yes }
        let orientationTotalPoints = orientationResultsPointed.map { $0.rawValue }.reduce(0, +)
        totalPoints += orientationTotalPoints

        let educationPoint: Int16 = testResults.selectedEducationOption == .secondOption ? 1 : 0
        totalPoints += educationPoint

        let resultType: ResultsModels.ResultType = totalPoints < 26 ? .bad : .excellent

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.visuospatial.localized,
                                                     description: "\(visuospatialTotalPoints) \(LocalizedTable.outOf.localized) 5 \(LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.naming.localized,
                                                     description: "\(namingTotalPoints) \(LocalizedTable.outOf.localized) 3 \(LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.attention.localized,
                                                     description: "\(attentionTotalPoints) \(LocalizedTable.outOf.localized) 6 \(LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.language.localized,
                                                     description: "\(languageTotalPoints) \(LocalizedTable.outOf.localized) 3 \(LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.abstraction.localized,
                                                     description: "\(abstractionTotalPoints) \(LocalizedTable.outOf.localized) 2 \(LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.delayedRecall.localized,
                                                     description: "\(delayedRecallTotalPoints) \(LocalizedTable.outOf.localized) 5 \(LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.orientation.localized,
                                                     description: "\(orientationTotalPoints) \(LocalizedTable.outOf.localized) 6 \(LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.totalScore.localized,
                                                     description: "\(totalPoints) \(totalPoints == 1 ? LocalizedTable.point.localized : LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultType == .excellent ?
                                                        LocalizedTable.moCAExcellentResult.localized
                                                        : LocalizedTable.moCABadResult.localized)]

        return (results, resultType)
    }

    private func getGeriatricDepressionScaleResults(for testResults: GeriatricDepressionScaleModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        var totalPoints: Int = 0

        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionOne] == .firstOption ? 0 : 1
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionTwo] == .firstOption ? 1 : 0
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionThree] == .firstOption ? 1 : 0
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionFour] == .firstOption ? 1 : 0
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionFive] == .firstOption ? 0 : 1
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionSix] == .firstOption ? 1 : 0
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionSeven] == .firstOption ? 0 : 1
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionEight] == .firstOption ? 1 : 0
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionNine] == .firstOption ? 1 : 0
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionTen] == .firstOption ? 1 : 0
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionEleven] == .firstOption ? 0 : 1
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionTwelve] == .firstOption ? 1 : 0
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionThirteen] == .firstOption ? 0 : 1
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionFourteen] == .firstOption ? 1 : 0
        totalPoints += testResults.questions[.geriatricDepressionScaleQuestionFifteen] == .firstOption ? 1 : 0

        let resultType: ResultsModels.ResultType = totalPoints > 5 ? .bad : .excellent

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.totalScore.localized,
                                                     description: "\(totalPoints) \(totalPoints == 1 ? LocalizedTable.point.localized : LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultType == .excellent ?
                                                        LocalizedTable.geriatricDepressionScaleExcellentResult.localized
                                                        : LocalizedTable.geriatricDepressionScaleBadResult.localized)]

        return (results, resultType)
    }

    private func getVisualAcuityAssessmentResults(for testResults: VisualAcuityAssessmentModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {

        let resultType: ResultsModels.ResultType

        let score: Double?
        let selectedOptionText: String?

        switch testResults.selectedOption {
        case .none:
            selectedOptionText = nil
            score = 0
            resultType = .bad
        case .firstOption:
            selectedOptionText = LocalizedTable.twentySlashTwoHundred.localized
            score = Double(LocalizedTable.twentySlashTwoHundredValue.localized)
            resultType = .bad
        case .secondOption:
            selectedOptionText = LocalizedTable.twentySlashOneHundred.localized
            score = Double(LocalizedTable.twentySlashOneHundredValue.localized)
            resultType = .medium
        case .thirdOption:
            selectedOptionText = LocalizedTable.twentySlashSeventy.localized
            score = Double(LocalizedTable.twentySlashSeventyValue.localized)
            resultType = .medium
        case .fourthOption:
            selectedOptionText = LocalizedTable.twentySlashSixty.localized
            score = Double(LocalizedTable.twentySlashSixtyValue.localized)
            resultType = .good
        case .fifthOption:
            selectedOptionText = LocalizedTable.twentySlashFifty.localized
            score = Double(LocalizedTable.twentySlashFiftyValue.localized)
            resultType = .good
        case .sixthOption:
            selectedOptionText = LocalizedTable.twentySlashFourty.localized
            score = Double(LocalizedTable.twentySlashFourtyValue.localized)
            resultType = .good
        case .seventhOption:
            selectedOptionText = LocalizedTable.twentySlashThirty.localized
            score = Double(LocalizedTable.twentySlashThirtyValue.localized)
            resultType = .good
        case .eighthOption:
            selectedOptionText = LocalizedTable.twentySlashTwentyFive.localized
            score = Double(LocalizedTable.twentySlashTwentyFiveValue.localized)
            resultType = .excellent
        case .ninthOption:
            selectedOptionText = LocalizedTable.twentySlashTwenty.localized
            score = Double(LocalizedTable.twentySlashTwentyValue.localized)
            resultType = .excellent
        case .tenthOption:
            selectedOptionText = LocalizedTable.twentySlashFifteen.localized
            score = Double(LocalizedTable.twentySlashFifteenValue.localized)
            resultType = .excellent
        case .eleventhOption:
            selectedOptionText = LocalizedTable.twentySlashThirteen.localized
            score = Double(LocalizedTable.twentySlashThirteenValue.localized)
            resultType = .excellent
        case .twelfthOption:
            selectedOptionText = LocalizedTable.twentySlashTen.localized
            score = Double(LocalizedTable.twentySlashTenValue.localized)
            resultType = .excellent
        case .thirteenthOption:
            selectedOptionText = LocalizedTable.twentySlashEight.localized
            score = Double(LocalizedTable.twentySlashEightValue.localized)
            resultType = .excellent
        case .fourteenthOption:
            selectedOptionText = LocalizedTable.twentySlashSix.localized
            score = Double(LocalizedTable.twentySlashSixValue.localized)
            resultType = .excellent
        case .fifteenthOption:
            selectedOptionText = LocalizedTable.twentySlashFive.localized
            score = Double(LocalizedTable.twentySlashFiveValue.localized)
            resultType = .excellent
        case .sixteenthOption:
            selectedOptionText = LocalizedTable.twentySlashFour.localized
            score = Double(LocalizedTable.twentySlashFourValue.localized)
            resultType = .excellent
        }

        let diagnosis: LocalizedTable = switch resultType {
        case .excellent:
            .visualAcuityAssessmentExcellentResult
        case .good:
            .visualAcuityAssessmentGoodResult
        case .medium:
            .visualAcuityAssessmentMediumResult
        case .bad:
            .visualAcuityAssessmentBadResult
        }

        let dynamicResult = LocalizedTable.visualAcuityDynamicResult.localized.replacingOccurrences(of: "%DISTANCE", with: (score ?? 0).regionFormatted(fractionDigits: 1))

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.scoreAchieved.localized, description: selectedOptionText ?? ""),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: "\(diagnosis.localized) \(dynamicResult)")]

        return (results, resultType)
    }

    private func getKatzScaleResults(for testResults: KatzScaleModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        let selectedOptions = testResults.questions.values.map { $0 as SelectableKeys }

        let selectedOptionsPointed = selectedOptions.filter { $0 == .firstOption }
        let totalPoints = selectedOptionsPointed.map { $0.rawValue }.reduce(0, +)

        let resultType: ResultsModels.ResultType = totalPoints > 4 ? .excellent : totalPoints > 2 ? .medium : .bad

        let resultText: LocalizedTable = switch resultType {
        case .excellent: .katzScaleExcellentResult
        case .medium: .katzScaleMediumResult
        case .bad: .katzScaleBadResult
        case .good: .none
        }

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.totalScore.localized,
                                                     description: "\(totalPoints) \(totalPoints == 1 ? LocalizedTable.point.localized : LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultText.localized)]

        return (results, resultType)
    }

    private func getLawtonScaleResults(for testResults: LawtonScaleModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        let selectedOptions = testResults.questions.values.map { $0 as SelectableKeys }

        let totalPoints = selectedOptions.filter { $0 == .firstOption }.count * 3 + selectedOptions.filter { $0 == .secondOption }.count * 2 + selectedOptions.filter { $0 == .thirdOption }.count

        let resultType: ResultsModels.ResultType = totalPoints > 18 ? .excellent : totalPoints > 14 ? .good : totalPoints > 10 ? .medium : .bad

        let resultText: LocalizedTable = switch resultType {
        case .excellent: .lawtonScaleExcellentResult
        case .good: .lawtonScaleGoodResult
        case .medium: .lawtonScaleMediumResult
        case .bad: totalPoints == 7 ? .lawtonScaleVeryBadResult : .lawtonScaleBadResult
        }

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.totalScore.localized,
                                                     description: "\(totalPoints) \(LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultText.localized)]

        return (results, resultType)
    }

    private func getMiniNutritionalAsessmentResults(for testResults: MiniNutritionalAssessmentModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        let selectedOptions: [SelectableKeys]
        let bmiPoints: Int
        let bmi: Double

        selectedOptions = testResults.questions.filter({ $0.key != .miniNutritionalAssessmentSeventhQuestion &&
                                                        $0.key != .miniNutritionalAssessmentFourthQuestion }).values.map { $0 as SelectableKeys }
        let fourthQuestionPoints = testResults.questions[.miniNutritionalAssessmentFourthQuestion] == .secondOption ? 2 : 0

        if testResults.isExtraQuestionSelected {
            let extraQuestionOption = testResults.questions[.miniNutritionalAssessmentSeventhQuestion]
            bmiPoints = extraQuestionOption == .firstOption ? 0 : 3
            bmi = 0
        } else {
            guard let height = testResults.height, let weight = testResults.weight else { return ([], .bad) }

            bmi = weight / (pow((height / 100), 2))

            bmiPoints = switch bmi {
            case 0..<19: 0
            case 19..<21: 1
            case 21..<23: 2
            case 23...: 3
            default: 0
            }
        }

        let selectedOptionsPointed = selectedOptions.filter { $0 == .firstOption }.count * 0 + selectedOptions.filter { $0 == .secondOption }.count * 1 +
            selectedOptions.filter { $0 == .thirdOption }.count * 2 + selectedOptions.filter { $0 == .fourthOption }.count * 3 + fourthQuestionPoints
        let totalPoints = bmiPoints + selectedOptionsPointed

        let resultType: ResultsModels.ResultType = totalPoints < 8 ? .bad : totalPoints < 12 ? .medium : .excellent

        let resultText: LocalizedTable = switch resultType {
        case .excellent: .miniNutritionalAssessmentExcellentResult
        case .medium: .miniNutritionalAssessmentMediumResult
        case .bad: .miniNutritionalAssessmentBadResult
        case .good: .none
        }

        var results: [ResultsModels.Result] = [.init(title: LocalizedTable.totalScore.localized,
                                                     description: "\(totalPoints) \(totalPoints == 1 ? LocalizedTable.point.localized : LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultText.localized)]

        if bmi > 0 { results.insert(.init(title: LocalizedTable.bmi.localized, description: "\(bmi.regionFormatted()) kg/m²"), at: 1) }

        return (results, resultType)
    }

    private func getApgarScaleResults(for testResults: ApgarScaleModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        let selectedOptions = testResults.questions.values.map { $0 as SelectableKeys }

        let totalPoints = selectedOptions.filter { $0 == .firstOption }.count * 0 + selectedOptions.filter { $0 == .secondOption }.count * 1 +
            selectedOptions.filter { $0 == .thirdOption }.count * 2

        let resultType: ResultsModels.ResultType = totalPoints < 4 ? .bad : totalPoints < 7 ? .medium : .excellent

        let resultText: LocalizedTable = switch resultType {
        case .excellent: .apgarScaleExcellentResult
        case .medium: .apgarScaleMediumResult
        case .bad: .apgarScaleBadResult
        case .good: .none
        }

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.totalScore.localized,
                                                     description: "\(totalPoints) \(totalPoints == 1 ? LocalizedTable.point.localized : LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultText.localized)]

        return (results, resultType)
    }

    private func getZaritScaleResults(for testResults: ZaritScaleModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        let selectedOptions = testResults.questions.values.map { $0 as SelectableKeys }

        var totalPoints = selectedOptions.filter { $0 == .firstOption }.count * 1 + selectedOptions.filter { $0 == .secondOption }.count * 2 + selectedOptions.filter { $0 == .thirdOption }.count * 3
        totalPoints += selectedOptions.filter { $0 == .fourthOption }.count * 4 + selectedOptions.filter { $0 == .fifthOption }.count * 5

        let resultType: ResultsModels.ResultType = totalPoints < 15 ? .excellent : totalPoints < 22 ? .medium : .bad

        let resultText: LocalizedTable = switch resultType {
        case .excellent: .zaritScaleExcellentResult
        case .medium: .zaritScaleMediumResult
        case .bad: .zaritScaleBadResult
        case .good: .none
        }

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.totalScore.localized,
                                                     description: "\(totalPoints) \(LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultText.localized)]

        return (results, resultType)
    }

    private func getPolypharmacyCriteriaResults(for testResults: PolypharmacyCriteriaModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        let resultType: ResultsModels.ResultType = testResults.numberOfMedicines > 4 ? .bad : .excellent

        let resultText: LocalizedTable = switch resultType {
        case .excellent: .polypharmacyCriteriaExcellentResult
        case .bad: .polypharmacyCriteriaBadResult
        default: .none
        }

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.numberOfMedicines.localized,
                                                     description: "\(testResults.numberOfMedicines) \(testResults.numberOfMedicines == 1 ? LocalizedTable.medicineSingular.localized : LocalizedTable.medicinePlural.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultText.localized)]

        return (results, resultType)
    }

    private func getCharlsonIndexResults(for testResults: CharlsonIndexModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        let binaryOptionsDictionaries = testResults.binaryQuestions.map { $0.value }

        let weightOneResults = binaryOptionsDictionaries.reduce([]) { partialResult, dictionary in
            partialResult + dictionary.filter { $0.key < 10 }.map { $0.value }
        }

        let weightTwoResults = binaryOptionsDictionaries.reduce([]) { partialResult, dictionary in
            partialResult + dictionary.filter { $0.key > 9 && $0.key < 16 }.map { $0.value }
        }

        let weightThreeResults = binaryOptionsDictionaries.reduce([]) { partialResult, dictionary in
            partialResult + dictionary.filter { $0.key == 16 }.map { $0.value }
        }

        let weightSixResults = binaryOptionsDictionaries.reduce([]) { partialResult, dictionary in
            partialResult + dictionary.filter { $0.key > 16 }.map { $0.value }
        }

        let weightOneResultsPointed = weightOneResults.filter { $0 == .yes }.count
        let weightTwoResultsPointed = weightTwoResults.filter { $0 == .yes }.count * 2
        let weightThreeResultsPointed = weightThreeResults.filter { $0 == .yes }.count * 3
        let weightSixResultsPointed = weightSixResults.filter { $0 == .yes }.count * 6

        let patientAgePoints: Int

        if let birthDate = testResults.patientBirthDate {
            switch birthDate.yearSinceCurrentDate {
            case 0...49:
                patientAgePoints = 0
            case 50...59:
                patientAgePoints = 1
            case 60...69:
                patientAgePoints = 2
            case 70...79:
                patientAgePoints = 3
            case 80...89:
                patientAgePoints = 4
            case 90...:
                patientAgePoints = 5
            default:
                patientAgePoints = 0
            }
        } else {
            patientAgePoints = 0
        }

        let totalPoints = weightOneResultsPointed + weightTwoResultsPointed + weightThreeResultsPointed + weightSixResultsPointed + patientAgePoints

        let resultType: ResultsModels.ResultType = totalPoints < 1 ? .excellent : totalPoints < 3 ? .good : totalPoints < 5 ? .medium : .bad

        let resultText: LocalizedTable = switch resultType {
        case .excellent: .charlsonIndexExcellentResult
        case .good: .charlsonIndexGoodResult
        case .medium: .charlsonIndexMediumResult
        case .bad: .charlsonIndexBadResult
        }

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.totalScore.localized,
                                                     description: "\(totalPoints) \(totalPoints == 1 ? LocalizedTable.point.localized : LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultText.localized)]

        return (results, resultType)
    }

    private func getChemotherapyToxicityRiskResults(for testResults: ChemotherapyToxicityRiskModels.TestResults) -> ([ResultsModels.Result], ResultsModels.ResultType) {
        var totalPoints: Int = 0

        totalPoints += testResults.questions[.chemotherapyToxicityRiskQuestionOne] == .firstOption ? 2 : 0
        totalPoints += testResults.questions[.chemotherapyToxicityRiskQuestionTwo] == .firstOption ? 2 : 0
        totalPoints += testResults.questions[.chemotherapyToxicityRiskQuestionThree] == .firstOption ? 2 : 0
        totalPoints += testResults.questions[.chemotherapyToxicityRiskQuestionFour] == .firstOption ? 3 : 0
        totalPoints += testResults.questions[.chemotherapyToxicityRiskQuestionFive] == .firstOption ? 3 : 0
        totalPoints += testResults.questions[.chemotherapyToxicityRiskQuestionSix] == .firstOption ? 2 : 0
        totalPoints += testResults.questions[.chemotherapyToxicityRiskQuestionSeven] == .firstOption ? 3 : 0
        totalPoints += testResults.questions[.chemotherapyToxicityRiskQuestionEight] == .firstOption ? 1 : 0
        totalPoints += testResults.questions[.chemotherapyToxicityRiskQuestionNine] == .firstOption ? 2 : 0
        totalPoints += testResults.questions[.chemotherapyToxicityRiskQuestionTen] == .firstOption ? 1 : 0
        totalPoints += testResults.questions[.chemotherapyToxicityRiskQuestionEleven] == .firstOption ? 2 : 0

        let resultType: ResultsModels.ResultType = totalPoints < 6 ? .excellent : totalPoints < 10 ? .medium : .bad

        let resultText: LocalizedTable = switch resultType {
        case .excellent: .chemotherapyToxicityRiskExcellentResult
        case .medium: .chemotherapyToxicityRiskMediumResult
        case .bad: .chemotherapyToxicityRiskBadResult
        case .good: .none
        }

        let results: [ResultsModels.Result] = [.init(title: LocalizedTable.totalScore.localized,
                                                     description: "\(totalPoints) \(totalPoints == 1 ? LocalizedTable.point.localized : LocalizedTable.points.localized)"),
                                               .init(title: LocalizedTable.suggestedDiagnosis.localized, description: resultText.localized)]

        return (results, resultType)
    }
}
