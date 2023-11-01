//
//  ResultsWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 31/10/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class ResultsWorkerTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?
    private var dao: CoreDataDAOMock?

    // MARK: - Life Cycle

    override func setUp() {
        super.setUp()
        dao = CoreDataDAOMock()
        try? dao?.addStandaloneCGA()
    }

    override func tearDown() {
        super.tearDown()
        currentExpectation = nil
        dao = nil
    }

    // MARK: - Test Methods

    func testGetTimedUpAndGoResults() {
        let newExpectation = expectation(description: "Call getResults for TimedUpAndGo")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .timedUpAndGo, results: TimedUpAndGoModels.TestResults(elapsedTime: 9))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.timedUpAndGoExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .timedUpAndGo, results: TimedUpAndGoModels.TestResults(elapsedTime: 11))
        XCTAssertEqual(results?.1, .good)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.timedUpAndGoGoodResult.localized }) ?? false)

        results = worker.getResults(for: .timedUpAndGo, results: TimedUpAndGoModels.TestResults(elapsedTime: 22))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.timedUpAndGoMediumResult.localized }) ?? false)

        results = worker.getResults(for: .timedUpAndGo, results: TimedUpAndGoModels.TestResults(elapsedTime: 32))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.timedUpAndGoBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetWalkingSpeedResults() {
        let newExpectation = expectation(description: "Call getResults for WalkingSpeed")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .walkingSpeed, results: WalkingSpeedModels.TestResults(firstElapsedTime: 2, secondElapsedTime: 3, thirdElapsedTime: 2))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.walkingSpeedExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .walkingSpeed, results: WalkingSpeedModels.TestResults(firstElapsedTime: 15, secondElapsedTime: 20, thirdElapsedTime: 18))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.walkingSpeedBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetCalfCircumferenceResults() {
        let newExpectation = expectation(description: "Call getResults for CalfCircumference")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .calfCircumference, results: CalfCircumferenceModels.TestResults(circumference: 34))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.calfCircumferenceExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .calfCircumference, results: CalfCircumferenceModels.TestResults(circumference: 28))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.calfCircumferenceBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetGripStrengthResults() {
        let newExpectation = expectation(description: "Call getResults for GripStrength")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .gripStrength, results: GripStrengthModels.TestResults(firstMeasurement: 16, secondMeasurement: 17, thirdMeasurement: 18, gender: .female))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.gripStrengthExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .gripStrength, results: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15, thirdMeasurement: 16, gender: .female))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.gripStrengthBadResult.localized }) ?? false)

        results = worker.getResults(for: .gripStrength, results: GripStrengthModels.TestResults(firstMeasurement: 27, secondMeasurement: 28, thirdMeasurement: 29, gender: .male))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.gripStrengthExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .gripStrength, results: GripStrengthModels.TestResults(firstMeasurement: 26, secondMeasurement: 24, thirdMeasurement: 27, gender: .male))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.gripStrengthBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetSarcopeniaScreeningResults() {
        let newExpectation = expectation(description: "Call getResults for SarcopeniaScreening")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .sarcopeniaScreening, results: SarcopeniaScreeningModels.TestResults(questions: [.sarcopeniaAssessmentFirstQuestion: .firstOption, .sarcopeniaAssessmentSecondQuestion: .secondOption,
                                                                                                                          .sarcopeniaAssessmentThirdQuestion: .thirdOption, .sarcopeniaAssessmentFourthQuestion: .firstOption,
                                                                                                                          .sarcopeniaAssessmentFifthQuestion: .firstOption, .sarcopeniaAssessmentSixthQuestion: .firstOption], gender: .male))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaScreeningExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .sarcopeniaScreening, results: SarcopeniaScreeningModels.TestResults(questions: [.sarcopeniaAssessmentFirstQuestion: .firstOption, .sarcopeniaAssessmentSecondQuestion: .secondOption,
                                                                                                                          .sarcopeniaAssessmentThirdQuestion: .firstOption, .sarcopeniaAssessmentFourthQuestion: .firstOption,
                                                                                                                          .sarcopeniaAssessmentFifthQuestion: .firstOption, .sarcopeniaAssessmentSixthQuestion: .firstOption], gender: .male))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaScreeningExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .sarcopeniaScreening, results: SarcopeniaScreeningModels.TestResults(questions: [.sarcopeniaAssessmentFirstQuestion: .firstOption, .sarcopeniaAssessmentSecondQuestion: .secondOption,
                                                                                                                          .sarcopeniaAssessmentThirdQuestion: .thirdOption, .sarcopeniaAssessmentFourthQuestion: .firstOption,
                                                                                                                          .sarcopeniaAssessmentFifthQuestion: .firstOption, .sarcopeniaAssessmentSixthQuestion: .secondOption], gender: .female))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaScreeningBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetSarcopeniaAssessmentResults() {
        let newExpectation = expectation(description: "Call getResults for SarcopeniaAssessment")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 16, secondMeasurement: 17,
                                                                                                                                        thirdMeasurement: 18, gender: .female),
                                                                                    calfCircumferenceResults: nil, timedUpAndGoResults: nil, walkingSpeedResults: nil))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: CalfCircumferenceModels.TestResults(circumference: 34),
                                                                                    timedUpAndGoResults: nil, walkingSpeedResults: nil))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentGoodResult.localized }) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: CalfCircumferenceModels.TestResults(circumference: 20),
                                                                                    timedUpAndGoResults: TimedUpAndGoModels.TestResults(elapsedTime: 9),
                                                                                    walkingSpeedResults: WalkingSpeedModels.TestResults(firstElapsedTime: 2, secondElapsedTime: 3, thirdElapsedTime: 2)))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentMediumResult.localized }) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: CalfCircumferenceModels.TestResults(circumference: 20),
                                                                                    timedUpAndGoResults: TimedUpAndGoModels.TestResults(elapsedTime: 30),
                                                                                    walkingSpeedResults: WalkingSpeedModels.TestResults(firstElapsedTime: 2, secondElapsedTime: 3, thirdElapsedTime: 2)))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentMediumResult.localized }) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: CalfCircumferenceModels.TestResults(circumference: 20), timedUpAndGoResults: nil,
                                                                                    walkingSpeedResults: WalkingSpeedModels.TestResults(firstElapsedTime: 2, secondElapsedTime: 3, thirdElapsedTime: 2)))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentMediumResult.localized }) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: CalfCircumferenceModels.TestResults(circumference: 20),
                                                                                    timedUpAndGoResults: TimedUpAndGoModels.TestResults(elapsedTime: 11), walkingSpeedResults: nil))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentMediumResult.localized }) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: CalfCircumferenceModels.TestResults(circumference: 20),
                                                                                    timedUpAndGoResults: TimedUpAndGoModels.TestResults(elapsedTime: 39), walkingSpeedResults: nil))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentBadResult.localized }) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: nil, timedUpAndGoResults: nil, walkingSpeedResults: nil))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.isEmpty ?? true)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetMiniMentalStateExamResults() {
        let newExpectation = expectation(description: "Call getResults for MiniMentalStateExam")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .miniMentalStateExamination, results: MiniMentalStateExamModels.TestResults(questions: [.miniMentalStateExamFirstQuestion: .firstOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamFifthQuestion: .firstOption],
                                                                                                                     binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamSecondSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamThirdSectionQuestion: [1: .yes, 2: .yes, 3: .yes],
                                                                                                                                       .miniMentalStateExamFourthSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamFifthSectionQuestion: [1: .yes, 2: .yes, 3: .yes],
                                                                                                                                       .miniMentalStateExamSixthSectionQuestion: [1: .yes, 2: .yes],
                                                                                                                                       .miniMentalStateExamSeventhSectionQuestion: [1: .yes, 2: .yes, 3: .yes]]))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniMentalStateExamExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .miniMentalStateExamination, results: MiniMentalStateExamModels.TestResults(questions: [.miniMentalStateExamFirstQuestion: .firstOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamFifthQuestion: .firstOption],
                                                                                                                     binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamSecondSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamThirdSectionQuestion: [1: .not, 2: .not, 3: .not],
                                                                                                                                       .miniMentalStateExamFourthSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamFifthSectionQuestion: [1: .not, 2: .not, 3: .not],
                                                                                                                                       .miniMentalStateExamSixthSectionQuestion: [1: .not, 2: .not],
                                                                                                                                       .miniMentalStateExamSeventhSectionQuestion: [1: .not, 2: .not, 3: .not]]))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniMentalStateExamBadResult.localized }) ?? false)

        results = worker.getResults(for: .miniMentalStateExamination, results: MiniMentalStateExamModels.TestResults(questions: [.miniMentalStateExamFirstQuestion: .secondOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamFifthQuestion: .firstOption],
                                                                                                                     binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamSecondSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamThirdSectionQuestion: [1: .yes, 2: .yes, 3: .yes],
                                                                                                                                       .miniMentalStateExamFourthSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamFifthSectionQuestion: [1: .yes, 2: .yes, 3: .yes],
                                                                                                                                       .miniMentalStateExamSixthSectionQuestion: [1: .yes, 2: .yes],
                                                                                                                                       .miniMentalStateExamSeventhSectionQuestion: [1: .yes, 2: .yes, 3: .yes]]))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniMentalStateExamExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .miniMentalStateExamination, results: MiniMentalStateExamModels.TestResults(questions: [.miniMentalStateExamFirstQuestion: .secondOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamFifthQuestion: .firstOption],
                                                                                                                     binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamSecondSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamThirdSectionQuestion: [1: .not, 2: .not, 3: .not],
                                                                                                                                       .miniMentalStateExamFourthSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamFifthSectionQuestion: [1: .not, 2: .not, 3: .not],
                                                                                                                                       .miniMentalStateExamSixthSectionQuestion: [1: .not, 2: .not],
                                                                                                                                       .miniMentalStateExamSeventhSectionQuestion: [1: .not, 2: .not, 3: .not]]))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniMentalStateExamBadResult.localized }) ?? false)

        results = worker.getResults(for: .miniMentalStateExamination, results: MiniMentalStateExamModels.TestResults(questions: [.miniMentalStateExamFirstQuestion: .thirdOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamFifthQuestion: .firstOption],
                                                                                                                     binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamSecondSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamThirdSectionQuestion: [1: .yes, 2: .yes, 3: .yes],
                                                                                                                                       .miniMentalStateExamFourthSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamFifthSectionQuestion: [1: .yes, 2: .yes, 3: .yes],
                                                                                                                                       .miniMentalStateExamSixthSectionQuestion: [1: .yes, 2: .yes],
                                                                                                                                       .miniMentalStateExamSeventhSectionQuestion: [1: .yes, 2: .yes, 3: .yes]]))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniMentalStateExamExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .miniMentalStateExamination, results: MiniMentalStateExamModels.TestResults(questions: [.miniMentalStateExamFirstQuestion: .thirdOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamFifthQuestion: .firstOption],
                                                                                                                     binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamSecondSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamThirdSectionQuestion: [1: .not, 2: .not, 3: .not],
                                                                                                                                       .miniMentalStateExamFourthSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamFifthSectionQuestion: [1: .not, 2: .not, 3: .not],
                                                                                                                                       .miniMentalStateExamSixthSectionQuestion: [1: .not, 2: .not],
                                                                                                                                       .miniMentalStateExamSeventhSectionQuestion: [1: .not, 2: .not, 3: .not]]))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniMentalStateExamBadResult.localized }) ?? false)

        results = worker.getResults(for: .miniMentalStateExamination, results: MiniMentalStateExamModels.TestResults(questions: [.miniMentalStateExamFirstQuestion: .fourthOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamFifthQuestion: .firstOption],
                                                                                                                     binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamSecondSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamThirdSectionQuestion: [1: .yes, 2: .yes, 3: .yes],
                                                                                                                                       .miniMentalStateExamFourthSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamFifthSectionQuestion: [1: .yes, 2: .yes, 3: .yes],
                                                                                                                                       .miniMentalStateExamSixthSectionQuestion: [1: .yes, 2: .yes],
                                                                                                                                       .miniMentalStateExamSeventhSectionQuestion: [1: .yes, 2: .yes, 3: .yes]]))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniMentalStateExamExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .miniMentalStateExamination, results: MiniMentalStateExamModels.TestResults(questions: [.miniMentalStateExamFirstQuestion: .fourthOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamFifthQuestion: .firstOption],
                                                                                                                     binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamSecondSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamThirdSectionQuestion: [1: .not, 2: .not, 3: .not],
                                                                                                                                       .miniMentalStateExamFourthSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamFifthSectionQuestion: [1: .not, 2: .not, 3: .not],
                                                                                                                                       .miniMentalStateExamSixthSectionQuestion: [1: .not, 2: .not],
                                                                                                                                       .miniMentalStateExamSeventhSectionQuestion: [1: .not, 2: .not, 3: .not]]))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniMentalStateExamBadResult.localized }) ?? false)

        results = worker.getResults(for: .miniMentalStateExamination, results: MiniMentalStateExamModels.TestResults(questions: [.miniMentalStateExamFirstQuestion: .fifthOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamFifthQuestion: .firstOption],
                                                                                                                     binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamSecondSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamThirdSectionQuestion: [1: .yes, 2: .yes, 3: .yes],
                                                                                                                                       .miniMentalStateExamFourthSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                                                       .miniMentalStateExamFifthSectionQuestion: [1: .yes, 2: .yes, 3: .yes],
                                                                                                                                       .miniMentalStateExamSixthSectionQuestion: [1: .yes, 2: .yes],
                                                                                                                                       .miniMentalStateExamSeventhSectionQuestion: [1: .yes, 2: .yes, 3: .yes]]))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniMentalStateExamExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .miniMentalStateExamination, results: MiniMentalStateExamModels.TestResults(questions: [.miniMentalStateExamFirstQuestion: .fifthOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                                                                                                                 .miniMentalStateExamFifthQuestion: .firstOption],
                                                                                                                     binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamSecondSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamThirdSectionQuestion: [1: .not, 2: .not, 3: .not],
                                                                                                                                       .miniMentalStateExamFourthSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamFifthSectionQuestion: [1: .not, 2: .not, 3: .not],
                                                                                                                                       .miniMentalStateExamSixthSectionQuestion: [1: .not, 2: .not],
                                                                                                                                       .miniMentalStateExamSeventhSectionQuestion: [1: .not, 2: .not, 3: .not]]))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniMentalStateExamBadResult.localized }) ?? false)

        results = worker.getResults(for: .miniMentalStateExamination, results: MiniMentalStateExamModels.TestResults(questions: [.miniMentalStateExamFirstQuestion: .sixthOption, .miniMentalStateExamSecondQuestion: .secondOption,
                                                                                                                                 .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .secondOption,
                                                                                                                                 .miniMentalStateExamFifthQuestion: .secondOption],
                                                                                                                     binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .yes, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamSecondSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamThirdSectionQuestion: [1: .not, 2: .not, 3: .not],
                                                                                                                                       .miniMentalStateExamFourthSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                                                       .miniMentalStateExamFifthSectionQuestion: [1: .not, 2: .not, 3: .not],
                                                                                                                                       .miniMentalStateExamSixthSectionQuestion: [1: .not, 2: .not],
                                                                                                                                       .miniMentalStateExamSeventhSectionQuestion: [1: .not, 2: .not, 3: .not]]))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniMentalStateExamBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetVerbalFluencyResults() {
        let newExpectation = expectation(description: "Call getResults for VerbalFluency")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .verbalFluencyTest, results: VerbalFluencyModels.TestResults(countedWords: 14, selectedEducationOption: .firstOption))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.verbalFluencyExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .verbalFluencyTest, results: VerbalFluencyModels.TestResults(countedWords: 11, selectedEducationOption: .firstOption))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.verbalFluencyBadResult.localized }) ?? false)

        results = worker.getResults(for: .verbalFluencyTest, results: VerbalFluencyModels.TestResults(countedWords: 14, selectedEducationOption: .secondOption))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.verbalFluencyExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .verbalFluencyTest, results: VerbalFluencyModels.TestResults(countedWords: 1, selectedEducationOption: .secondOption))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.verbalFluencyBadResult.localized }) ?? false)

        results = worker.getResults(for: .verbalFluencyTest, results: VerbalFluencyModels.TestResults(countedWords: 1, selectedEducationOption: .thirdOption))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.verbalFluencyBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetClockDrawingResults() {
        let newExpectation = expectation(description: "Call getResults for ClockDrawing")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .clockDrawingTest, results: ClockDrawingModels.TestResults(binaryQuestions: [
            .outline: [1: .yes, 2: .yes],
            .numbers: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes, 6: .yes],
            .pointers: [1: .not, 2: .yes, 3: .yes, 4: .yes, 5: .yes, 6: .yes]
        ]))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.clockDrawingExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .clockDrawingTest, results: ClockDrawingModels.TestResults(binaryQuestions: [
            .outline: [1: .not, 2: .not],
            .numbers: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not, 6: .not],
            .pointers: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not, 6: .yes]
        ]))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.clockDrawingBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetMoCAResults() {
        let newExpectation = expectation(description: "Call getResults for MoCA")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .moca, results: MoCAModels.TestResults(binaryQuestions: [.visuospatial: [1: .yes, 2: .not, 3: .yes, 4: .yes, 5: .yes],
                                                                                                  .naming: [1: .not, 2: .yes, 3: .yes],
                                                                                                  .mocaFourthSectionSecondInstruction: [1: .yes, 2: .yes],
                                                                                                  .mocaFourthSectionThirdInstruction: [1: .yes],
                                                                                                  .mocaFourthSectionFourthInstruction: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                                  .language: [1: .yes, 2: .not],
                                                                                                  .abstraction: [1: .yes, 2: .yes],
                                                                                                  .delayedRecall: [1: .yes, 2: .yes, 3: .not, 4: .yes, 5: .yes],
                                                                                                  .orientation: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes, 6: .yes]],
                                                                                selectedEducationOption: .firstOption, countedWords: 34))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.moCAExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .moca, results: MoCAModels.TestResults(binaryQuestions: [.visuospatial: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                  .naming: [1: .not, 2: .not, 3: .not],
                                                                                                  .mocaFourthSectionSecondInstruction: [1: .not, 2: .not],
                                                                                                  .mocaFourthSectionThirdInstruction: [1: .not],
                                                                                                  .mocaFourthSectionFourthInstruction: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                  .language: [1: .not, 2: .not],
                                                                                                  .abstraction: [1: .not, 2: .not],
                                                                                                  .delayedRecall: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                  .orientation: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not, 6: .not]],
                                                                                selectedEducationOption: .secondOption, countedWords: 5))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.moCABadResult.localized }) ?? false)

        results = worker.getResults(for: .moca, results: MoCAModels.TestResults(binaryQuestions: [.visuospatial: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                  .naming: [1: .not, 2: .not, 3: .not],
                                                                                                  .mocaFourthSectionSecondInstruction: [1: .not, 2: .not],
                                                                                                  .mocaFourthSectionThirdInstruction: [1: .not],
                                                                                                  .mocaFourthSectionFourthInstruction: [1: .yes, 2: .yes, 3: .yes, 4: .not, 5: .not],
                                                                                                  .language: [1: .not, 2: .not],
                                                                                                  .abstraction: [1: .not, 2: .not],
                                                                                                  .delayedRecall: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                                                  .orientation: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not, 6: .not]],
                                                                                selectedEducationOption: .secondOption, countedWords: 5))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.moCABadResult.localized }) ?? false)

        results = worker.getResults(for: .moca, results: MoCAModels.TestResults(binaryQuestions: [:],
                                                                                selectedEducationOption: .secondOption, countedWords: 5))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.moCABadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetGeriatricDepressionScaleResults() {
        let newExpectation = expectation(description: "Call getResults for GeriatricDepressionScale")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .geriatricDepressionScale,
                                    results: GeriatricDepressionScaleModels.TestResults(questions: [.geriatricDepressionScaleQuestionOne: .firstOption,
                                                                                                    .geriatricDepressionScaleQuestionTwo: .firstOption, .geriatricDepressionScaleQuestionThree: .firstOption,
                                                                                                    .geriatricDepressionScaleQuestionFour: .firstOption, .geriatricDepressionScaleQuestionFive: .firstOption,
                                                                                                    .geriatricDepressionScaleQuestionSix: .firstOption, .geriatricDepressionScaleQuestionSeven: .firstOption,
                                                                                                    .geriatricDepressionScaleQuestionEight: .firstOption, .geriatricDepressionScaleQuestionNine: .firstOption,
                                                                                                    .geriatricDepressionScaleQuestionTen: .firstOption, .geriatricDepressionScaleQuestionEleven: .firstOption,
                                                                                                    .geriatricDepressionScaleQuestionTwelve: .firstOption, .geriatricDepressionScaleQuestionThirteen: .firstOption,
                                                                                                    .geriatricDepressionScaleQuestionFourteen: .firstOption, .geriatricDepressionScaleQuestionFifteen: .firstOption]
                                    ))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.geriatricDepressionScaleBadResult.localized }) ?? false)

        results = worker.getResults(for: .geriatricDepressionScale,
                                    results: GeriatricDepressionScaleModels.TestResults(questions: [.geriatricDepressionScaleQuestionOne: .secondOption,
                                                                                                    .geriatricDepressionScaleQuestionTwo: .secondOption, .geriatricDepressionScaleQuestionThree: .secondOption,
                                                                                                    .geriatricDepressionScaleQuestionFour: .secondOption, .geriatricDepressionScaleQuestionFive: .secondOption,
                                                                                                    .geriatricDepressionScaleQuestionSix: .secondOption, .geriatricDepressionScaleQuestionSeven: .secondOption,
                                                                                                    .geriatricDepressionScaleQuestionEight: .secondOption, .geriatricDepressionScaleQuestionNine: .secondOption,
                                                                                                    .geriatricDepressionScaleQuestionTen: .secondOption, .geriatricDepressionScaleQuestionEleven: .secondOption,
                                                                                                    .geriatricDepressionScaleQuestionTwelve: .secondOption, .geriatricDepressionScaleQuestionThirteen: .secondOption,
                                                                                                    .geriatricDepressionScaleQuestionFourteen: .secondOption, .geriatricDepressionScaleQuestionFifteen: .secondOption]
                                    ))

        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.geriatricDepressionScaleExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .geriatricDepressionScale,
                                    results: GeriatricDepressionScaleModels.TestResults(questions: [.geriatricDepressionScaleQuestionOne: .firstOption,
                                                                                                    .geriatricDepressionScaleQuestionTwo: .secondOption, .geriatricDepressionScaleQuestionThree: .secondOption,
                                                                                                    .geriatricDepressionScaleQuestionFour: .secondOption, .geriatricDepressionScaleQuestionFive: .firstOption,
                                                                                                    .geriatricDepressionScaleQuestionSix: .secondOption, .geriatricDepressionScaleQuestionSeven: .firstOption,
                                                                                                    .geriatricDepressionScaleQuestionEight: .secondOption, .geriatricDepressionScaleQuestionNine: .secondOption,
                                                                                                    .geriatricDepressionScaleQuestionTen: .secondOption, .geriatricDepressionScaleQuestionEleven: .firstOption,
                                                                                                    .geriatricDepressionScaleQuestionTwelve: .firstOption, .geriatricDepressionScaleQuestionThirteen: .firstOption,
                                                                                                    .geriatricDepressionScaleQuestionFourteen: .secondOption, .geriatricDepressionScaleQuestionFifteen: .secondOption]
                                    ))

        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.geriatricDepressionScaleExcellentResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetVisualAcuityAssessmentResults() {
        let newExpectation = expectation(description: "Call getResults for VisualAcuityAssessment")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .none))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentBadResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .firstOption))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentBadResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .secondOption))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentMediumResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .thirdOption))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentMediumResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .fourthOption))
        XCTAssertEqual(results?.1, .good)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentGoodResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .fifthOption))
        XCTAssertEqual(results?.1, .good)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentGoodResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .sixthOption))
        XCTAssertEqual(results?.1, .good)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentGoodResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .seventhOption))
        XCTAssertEqual(results?.1, .good)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentGoodResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .eighthOption))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentExcellentResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .ninthOption))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentExcellentResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .tenthOption))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentExcellentResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .eleventhOption))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentExcellentResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .twelfthOption))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentExcellentResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .thirteenthOption))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentExcellentResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .fourteenthOption))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentExcellentResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .fifteenthOption))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentExcellentResult.localized) }) ?? false)

        results = worker.getResults(for: .visualAcuityAssessment, results: VisualAcuityAssessmentModels.TestResults(selectedOption: .sixteenthOption))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description.contains(LocalizedTable.visualAcuityAssessmentExcellentResult.localized) }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetKatzScaleResults() {
        let newExpectation = expectation(description: "Call getResults for KatzScale")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .katzScale,
                                    results: KatzScaleModels.TestResults(questions: [
                                        .katzScaleQuestionOne: .firstOption, .katzScaleQuestionTwo: .secondOption, .katzScaleQuestionThree: .firstOption,
                                        .katzScaleQuestionFour: .firstOption, .katzScaleQuestionFive: .firstOption, .katzScaleQuestionSix: .firstOption
                                    ]))

        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.katzScaleExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .katzScale,
                                    results: KatzScaleModels.TestResults(questions: [
                                        .katzScaleQuestionOne: .secondOption, .katzScaleQuestionTwo: .secondOption, .katzScaleQuestionThree: .firstOption,
                                        .katzScaleQuestionFour: .firstOption, .katzScaleQuestionFive: .firstOption, .katzScaleQuestionSix: .firstOption
                                    ]))

        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.katzScaleMediumResult.localized }) ?? false)

        results = worker.getResults(for: .katzScale,
                                    results: KatzScaleModels.TestResults(questions: [
                                        .katzScaleQuestionOne: .secondOption, .katzScaleQuestionTwo: .secondOption, .katzScaleQuestionThree: .secondOption,
                                        .katzScaleQuestionFour: .secondOption, .katzScaleQuestionFive: .secondOption, .katzScaleQuestionSix: .firstOption
                                    ]))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.katzScaleBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetLawtonScaleResults() {
        let newExpectation = expectation(description: "Call getResults for LawtonScale")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .lawtonScale,
                                    results: LawtonScaleModels.TestResults(questions: [
                                        .telephone: .firstOption, .trips: .firstOption, .shopping: .firstOption, .mealPreparation: .firstOption,
                                        .housework: .secondOption, .medicine: .firstOption, .money: .firstOption
                                    ]))

        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.lawtonScaleExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .lawtonScale,
                                    results: LawtonScaleModels.TestResults(questions: [
                                        .telephone: .thirdOption, .trips: .secondOption, .shopping: .thirdOption, .mealPreparation: .firstOption,
                                        .housework: .secondOption, .medicine: .firstOption, .money: .firstOption
                                    ]))

        XCTAssertEqual(results?.1, .good)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.lawtonScaleGoodResult.localized }) ?? false)

        results = worker.getResults(for: .lawtonScale,
                                    results: LawtonScaleModels.TestResults(questions: [
                                        .telephone: .thirdOption, .trips: .thirdOption, .shopping: .thirdOption, .mealPreparation: .thirdOption,
                                        .housework: .secondOption, .medicine: .firstOption, .money: .firstOption
                                    ]))

        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.lawtonScaleMediumResult.localized }) ?? false)

        results = worker.getResults(for: .lawtonScale,
                                    results: LawtonScaleModels.TestResults(questions: [
                                        .telephone: .thirdOption, .trips: .thirdOption, .shopping: .thirdOption, .mealPreparation: .thirdOption,
                                        .housework: .secondOption, .medicine: .thirdOption, .money: .thirdOption
                                    ]))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.lawtonScaleBadResult.localized }) ?? false)

        results = worker.getResults(for: .lawtonScale,
                                    results: LawtonScaleModels.TestResults(questions: [
                                        .telephone: .thirdOption, .trips: .thirdOption, .shopping: .thirdOption, .mealPreparation: .thirdOption,
                                        .housework: .thirdOption, .medicine: .thirdOption, .money: .thirdOption
                                    ]))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.lawtonScaleVeryBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetMiniNutritionalAssessmentResults() {
        let newExpectation = expectation(description: "Call getResults for MiniNutritionalAssessment")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .miniNutritionalAssessment,
                                    results: MiniNutritionalAssessmentModels.TestResults(questions: [
                                        .miniNutritionalAssessmentFirstQuestion: .thirdOption, .miniNutritionalAssessmentSecondQuestion: .fourthOption,
                                        .miniNutritionalAssessmentThirdQuestion: .thirdOption, .miniNutritionalAssessmentFourthQuestion: .secondOption,
                                        .miniNutritionalAssessmentFifthQuestion: .thirdOption, .miniNutritionalAssessmentSeventhQuestion: .secondOption
                                    ], height: 174, weight: 80.5, isExtraQuestionSelected: true))

        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniNutritionalAssessmentExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .miniNutritionalAssessment,
                                    results: MiniNutritionalAssessmentModels.TestResults(questions: [
                                        .miniNutritionalAssessmentFirstQuestion: .thirdOption, .miniNutritionalAssessmentSecondQuestion: .fourthOption,
                                        .miniNutritionalAssessmentThirdQuestion: .thirdOption, .miniNutritionalAssessmentFourthQuestion: .firstOption,
                                        .miniNutritionalAssessmentFifthQuestion: .thirdOption, .miniNutritionalAssessmentSeventhQuestion: .firstOption
                                    ], height: 174, weight: 80.5, isExtraQuestionSelected: true))

        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniNutritionalAssessmentMediumResult.localized }) ?? false)

        results = worker.getResults(for: .miniNutritionalAssessment,
                                    results: MiniNutritionalAssessmentModels.TestResults(questions: [
                                        .miniNutritionalAssessmentFirstQuestion: .firstOption, .miniNutritionalAssessmentSecondQuestion: .firstOption,
                                        .miniNutritionalAssessmentThirdQuestion: .firstOption, .miniNutritionalAssessmentFourthQuestion: .firstOption,
                                        .miniNutritionalAssessmentFifthQuestion: .secondOption, .miniNutritionalAssessmentSeventhQuestion: .none
                                    ], height: 104, weight: 19.5, isExtraQuestionSelected: false))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniNutritionalAssessmentBadResult.localized }) ?? false)

        results = worker.getResults(for: .miniNutritionalAssessment,
                                    results: MiniNutritionalAssessmentModels.TestResults(questions: [
                                        .miniNutritionalAssessmentFirstQuestion: .thirdOption, .miniNutritionalAssessmentSecondQuestion: .fourthOption,
                                        .miniNutritionalAssessmentThirdQuestion: .thirdOption, .miniNutritionalAssessmentFourthQuestion: .firstOption,
                                        .miniNutritionalAssessmentFifthQuestion: .thirdOption, .miniNutritionalAssessmentSeventhQuestion: .none
                                    ], height: 104, weight: 22.5, isExtraQuestionSelected: false))

        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniNutritionalAssessmentMediumResult.localized }) ?? false)

        results = worker.getResults(for: .miniNutritionalAssessment,
                                    results: MiniNutritionalAssessmentModels.TestResults(questions: [
                                        .miniNutritionalAssessmentFirstQuestion: .thirdOption, .miniNutritionalAssessmentSecondQuestion: .fourthOption,
                                        .miniNutritionalAssessmentThirdQuestion: .thirdOption, .miniNutritionalAssessmentFourthQuestion: .firstOption,
                                        .miniNutritionalAssessmentFifthQuestion: .thirdOption, .miniNutritionalAssessmentSeventhQuestion: .none
                                    ], height: 104, weight: 24, isExtraQuestionSelected: false))

        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniNutritionalAssessmentMediumResult.localized }) ?? false)

        results = worker.getResults(for: .miniNutritionalAssessment,
                                    results: MiniNutritionalAssessmentModels.TestResults(questions: [
                                        .miniNutritionalAssessmentFirstQuestion: .thirdOption, .miniNutritionalAssessmentSecondQuestion: .fourthOption,
                                        .miniNutritionalAssessmentThirdQuestion: .thirdOption, .miniNutritionalAssessmentFourthQuestion: .firstOption,
                                        .miniNutritionalAssessmentFifthQuestion: .thirdOption, .miniNutritionalAssessmentSeventhQuestion: .none
                                    ], height: 104, weight: 27, isExtraQuestionSelected: false))

        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniNutritionalAssessmentExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .miniNutritionalAssessment,
                                    results: MiniNutritionalAssessmentModels.TestResults(questions: [
                                        .miniNutritionalAssessmentFirstQuestion: .thirdOption, .miniNutritionalAssessmentSecondQuestion: .fourthOption,
                                        .miniNutritionalAssessmentThirdQuestion: .thirdOption, .miniNutritionalAssessmentFourthQuestion: .firstOption,
                                        .miniNutritionalAssessmentFifthQuestion: .thirdOption, .miniNutritionalAssessmentSeventhQuestion: .none
                                    ], height: 104, weight: -27, isExtraQuestionSelected: false))

        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.miniNutritionalAssessmentMediumResult.localized }) ?? false)

        results = worker.getResults(for: .miniNutritionalAssessment,
                                    results: MiniNutritionalAssessmentModels.TestResults(questions: [
                                        .miniNutritionalAssessmentFirstQuestion: .firstOption, .miniNutritionalAssessmentSecondQuestion: .firstOption,
                                        .miniNutritionalAssessmentThirdQuestion: .firstOption, .miniNutritionalAssessmentFourthQuestion: .firstOption,
                                        .miniNutritionalAssessmentFifthQuestion: .secondOption, .miniNutritionalAssessmentSeventhQuestion: .none
                                    ], height: nil, weight: nil, isExtraQuestionSelected: false))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.isEmpty ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetApgarScaleResults() {
        let newExpectation = expectation(description: "Call getResults for ApgarScale")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .apgarScale,
                                    results: ApgarScaleModels.TestResults(questions: [.apgarScaleQuestionOne: .secondOption, .apgarScaleQuestionTwo: .thirdOption, .apgarScaleQuestionThree: .thirdOption,
                                                                                      .apgarScaleQuestionFour: .firstOption, .apgarScaleQuestionFive: .thirdOption
                                    ]))

        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.apgarScaleExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .apgarScale,
                                    results: ApgarScaleModels.TestResults(questions: [.apgarScaleQuestionOne: .secondOption, .apgarScaleQuestionTwo: .thirdOption, .apgarScaleQuestionThree: .thirdOption,
                                                                                      .apgarScaleQuestionFour: .firstOption, .apgarScaleQuestionFive: .firstOption
                                    ]))

        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.apgarScaleMediumResult.localized }) ?? false)

        results = worker.getResults(for: .apgarScale,
                                    results: ApgarScaleModels.TestResults(questions: [.apgarScaleQuestionOne: .secondOption, .apgarScaleQuestionTwo: .firstOption, .apgarScaleQuestionThree: .firstOption,
                                                                                      .apgarScaleQuestionFour: .firstOption, .apgarScaleQuestionFive: .firstOption
                                    ]))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.apgarScaleBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetZaritScaleResults() {
        let newExpectation = expectation(description: "Call getResults for ZaritScale")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .zaritScale,
                                    results: ZaritScaleModels.TestResults(questions: [.zaritScaleQuestionOne: .firstOption, .zaritScaleQuestionTwo: .firstOption, .zaritScaleQuestionThree: .firstOption,
                                                                                      .zaritScaleQuestionFour: .firstOption, .zaritScaleQuestionFive: .secondOption, .zaritScaleQuestionSix: .secondOption,
                                                                                      .zaritScaleQuestionSeven: .secondOption
                                    ]))

        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.zaritScaleExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .zaritScale,
                                    results: ZaritScaleModels.TestResults(questions: [.zaritScaleQuestionOne: .firstOption, .zaritScaleQuestionTwo: .firstOption, .zaritScaleQuestionThree: .firstOption,
                                                                                      .zaritScaleQuestionFour: .firstOption, .zaritScaleQuestionFive: .fifthOption, .zaritScaleQuestionSix: .fifthOption,
                                                                                      .zaritScaleQuestionSeven: .fifthOption
                                    ]))

        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.zaritScaleMediumResult.localized }) ?? false)

        results = worker.getResults(for: .zaritScale,
                                    results: ZaritScaleModels.TestResults(questions: [.zaritScaleQuestionOne: .fifthOption, .zaritScaleQuestionTwo: .fifthOption, .zaritScaleQuestionThree: .fifthOption,
                                                                                      .zaritScaleQuestionFour: .thirdOption, .zaritScaleQuestionFive: .fifthOption, .zaritScaleQuestionSix: .fifthOption,
                                                                                      .zaritScaleQuestionSeven: .secondOption
                                    ]))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.zaritScaleBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetPolypharmacyCriteriaResults() {
        let newExpectation = expectation(description: "Call getResults for PolypharmacyCriteria")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .polypharmacyCriteria,
                                    results: PolypharmacyCriteriaModels.TestResults(numberOfMedicines: 1))

        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.polypharmacyCriteriaExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .polypharmacyCriteria,
                                    results: PolypharmacyCriteriaModels.TestResults(numberOfMedicines: 6))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.polypharmacyCriteriaBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetCharlsonIndexResults() {
        let newExpectation = expectation(description: "Call getResults for CharlsonIndex")
        currentExpectation = newExpectation

        let worker = ResultsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        var results: ([ResultsModels.Result], ResultsModels.ResultType)?

        results = worker.getResults(for: .charlsonIndex,
                                    results: CharlsonIndexModels.TestResults(binaryQuestions: [
                                        .charlsonIndexMainQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not, 6: .not,
                                                                     7: .not, 8: .not, 9: .not, 10: .not, 11: .not, 12: .not,
                                                                     13: .not, 14: .not, 15: .not, 16: .not, 17: .not, 18: .not]
                                    ], patientBirthDate: Date().addingYear(-45)))

        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.charlsonIndexExcellentResult.localized }) ?? false)

        results = worker.getResults(for: .charlsonIndex,
                                    results: CharlsonIndexModels.TestResults(binaryQuestions: [
                                        .charlsonIndexMainQuestion: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not, 6: .not,
                                                                     7: .not, 8: .not, 9: .not, 10: .not, 11: .not, 12: .not,
                                                                     13: .not, 14: .not, 15: .not, 16: .not, 17: .not, 18: .not]
                                    ], patientBirthDate: Date().addingYear(-55)))

        XCTAssertEqual(results?.1, .good)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.charlsonIndexGoodResult.localized }) ?? false)

        results = worker.getResults(for: .charlsonIndex,
                                    results: CharlsonIndexModels.TestResults(binaryQuestions: [
                                        .charlsonIndexMainQuestion: [1: .yes, 2: .not, 3: .yes, 4: .not, 5: .not, 6: .not,
                                                                     7: .not, 8: .not, 9: .not, 10: .not, 11: .not, 12: .not,
                                                                     13: .not, 14: .not, 15: .not, 16: .not, 17: .not, 18: .not]
                                    ], patientBirthDate: Date().addingYear(-65)))

        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.charlsonIndexMediumResult.localized }) ?? false)

        results = worker.getResults(for: .charlsonIndex,
                                    results: CharlsonIndexModels.TestResults(binaryQuestions: [
                                        .charlsonIndexMainQuestion: [1: .yes, 2: .not, 3: .yes, 4: .not, 5: .not, 6: .not,
                                                                     7: .not, 8: .not, 9: .not, 10: .not, 11: .not, 12: .not,
                                                                     13: .not, 14: .not, 15: .not, 16: .yes, 17: .yes, 18: .not]
                                    ], patientBirthDate: Date().addingYear(-75)))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.charlsonIndexBadResult.localized }) ?? false)

        results = worker.getResults(for: .charlsonIndex,
                                    results: CharlsonIndexModels.TestResults(binaryQuestions: [
                                        .charlsonIndexMainQuestion: [1: .yes, 2: .not, 3: .yes, 4: .not, 5: .not, 6: .not,
                                                                     7: .not, 8: .not, 9: .not, 10: .not, 11: .not, 12: .not,
                                                                     13: .not, 14: .not, 15: .not, 16: .yes, 17: .yes, 18: .not]
                                    ], patientBirthDate: Date().addingYear(-85)))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.charlsonIndexBadResult.localized }) ?? false)

        results = worker.getResults(for: .charlsonIndex,
                                    results: CharlsonIndexModels.TestResults(binaryQuestions: [
                                        .charlsonIndexMainQuestion: [1: .yes, 2: .not, 3: .yes, 4: .not, 5: .not, 6: .not,
                                                                     7: .not, 8: .not, 9: .not, 10: .not, 11: .not, 12: .not,
                                                                     13: .not, 14: .not, 15: .not, 16: .yes, 17: .yes, 18: .not]
                                    ], patientBirthDate: Date().addingYear(-95)))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.charlsonIndexBadResult.localized }) ?? false)

        results = worker.getResults(for: .charlsonIndex,
                                    results: CharlsonIndexModels.TestResults(binaryQuestions: [
                                        .charlsonIndexMainQuestion: [1: .yes, 2: .not, 3: .yes, 4: .not, 5: .not, 6: .not,
                                                                     7: .not, 8: .not, 9: .not, 10: .not, 11: .not, 12: .not,
                                                                     13: .not, 14: .not, 15: .not, 16: .yes, 17: .yes, 18: .not]
                                    ], patientBirthDate: Date().addingYear(15)))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.charlsonIndexBadResult.localized }) ?? false)

        results = worker.getResults(for: .charlsonIndex,
                                    results: CharlsonIndexModels.TestResults(binaryQuestions: [
                                        .charlsonIndexMainQuestion: [1: .yes, 2: .not, 3: .yes, 4: .not, 5: .not, 6: .not,
                                                                     7: .not, 8: .not, 9: .not, 10: .not, 11: .not, 12: .not,
                                                                     13: .not, 14: .not, 15: .not, 16: .yes, 17: .yes, 18: .not]
                                    ], patientBirthDate: nil))

        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.charlsonIndexBadResult.localized }) ?? false)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }
}
