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
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.timedUpAndGoExcellentResult.localized}) ?? false)

        results = worker.getResults(for: .timedUpAndGo, results: TimedUpAndGoModels.TestResults(elapsedTime: 11))
        XCTAssertEqual(results?.1, .good)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.timedUpAndGoGoodResult.localized}) ?? false)

        results = worker.getResults(for: .timedUpAndGo, results: TimedUpAndGoModels.TestResults(elapsedTime: 22))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.timedUpAndGoMediumResult.localized}) ?? false)

        results = worker.getResults(for: .timedUpAndGo, results: TimedUpAndGoModels.TestResults(elapsedTime: 32))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.timedUpAndGoBadResult.localized}) ?? false)

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
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.walkingSpeedExcellentResult.localized}) ?? false)

        results = worker.getResults(for: .walkingSpeed, results: WalkingSpeedModels.TestResults(firstElapsedTime: 15, secondElapsedTime: 20, thirdElapsedTime: 18))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.walkingSpeedBadResult.localized}) ?? false)

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
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.calfCircumferenceExcellentResult.localized}) ?? false)

        results = worker.getResults(for: .calfCircumference, results: CalfCircumferenceModels.TestResults(circumference: 28))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.calfCircumferenceBadResult.localized}) ?? false)

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
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.gripStrengthExcellentResult.localized}) ?? false)

        results = worker.getResults(for: .gripStrength, results: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15, thirdMeasurement: 16, gender: .female))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.gripStrengthBadResult.localized}) ?? false)

        results = worker.getResults(for: .gripStrength, results: GripStrengthModels.TestResults(firstMeasurement: 27, secondMeasurement: 28, thirdMeasurement: 29, gender: .male))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.gripStrengthExcellentResult.localized}) ?? false)

        results = worker.getResults(for: .gripStrength, results: GripStrengthModels.TestResults(firstMeasurement: 26, secondMeasurement: 24, thirdMeasurement: 27, gender: .male))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.gripStrengthBadResult.localized}) ?? false)

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
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaScreeningExcellentResult.localized}) ?? false)

        results = worker.getResults(for: .sarcopeniaScreening, results: SarcopeniaScreeningModels.TestResults(questions: [.sarcopeniaAssessmentFirstQuestion: .firstOption, .sarcopeniaAssessmentSecondQuestion: .secondOption,
                                                                                                                          .sarcopeniaAssessmentThirdQuestion: .firstOption, .sarcopeniaAssessmentFourthQuestion: .firstOption,
                                                                                                                          .sarcopeniaAssessmentFifthQuestion: .firstOption, .sarcopeniaAssessmentSixthQuestion: .firstOption], gender: .male))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaScreeningExcellentResult.localized}) ?? false)

        results = worker.getResults(for: .sarcopeniaScreening, results: SarcopeniaScreeningModels.TestResults(questions: [.sarcopeniaAssessmentFirstQuestion: .firstOption, .sarcopeniaAssessmentSecondQuestion: .secondOption,
                                                                                                                          .sarcopeniaAssessmentThirdQuestion: .thirdOption, .sarcopeniaAssessmentFourthQuestion: .firstOption,
                                                                                                                          .sarcopeniaAssessmentFifthQuestion: .firstOption, .sarcopeniaAssessmentSixthQuestion: .secondOption], gender: .female))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaScreeningBadResult.localized}) ?? false)

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
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentExcellentResult.localized}) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: CalfCircumferenceModels.TestResults(circumference: 34),
                                                                                    timedUpAndGoResults: nil, walkingSpeedResults: nil))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentGoodResult.localized}) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: CalfCircumferenceModels.TestResults(circumference: 20),
                                                                                    timedUpAndGoResults: TimedUpAndGoModels.TestResults(elapsedTime: 9),
                                                                                    walkingSpeedResults: WalkingSpeedModels.TestResults(firstElapsedTime: 2, secondElapsedTime: 3, thirdElapsedTime: 2)))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentMediumResult.localized}) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: CalfCircumferenceModels.TestResults(circumference: 20),
                                                                                    timedUpAndGoResults: TimedUpAndGoModels.TestResults(elapsedTime: 30),
                                                                                    walkingSpeedResults: WalkingSpeedModels.TestResults(firstElapsedTime: 2, secondElapsedTime: 3, thirdElapsedTime: 2)))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentMediumResult.localized}) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: CalfCircumferenceModels.TestResults(circumference: 20), timedUpAndGoResults: nil,
                                                                                    walkingSpeedResults: WalkingSpeedModels.TestResults(firstElapsedTime: 2, secondElapsedTime: 3, thirdElapsedTime: 2)))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentMediumResult.localized}) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: CalfCircumferenceModels.TestResults(circumference: 20),
                                                                                    timedUpAndGoResults: TimedUpAndGoModels.TestResults(elapsedTime: 11), walkingSpeedResults: nil))
        XCTAssertEqual(results?.1, .medium)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentMediumResult.localized}) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: CalfCircumferenceModels.TestResults(circumference: 20),
                                                                                    timedUpAndGoResults: TimedUpAndGoModels.TestResults(elapsedTime: 39), walkingSpeedResults: nil))
        XCTAssertEqual(results?.1, .bad)
        XCTAssertTrue(results?.0.contains(where: { $0.description == LocalizedTable.sarcopeniaAssessmentBadResult.localized}) ?? false)

        results = worker.getResults(for: .sarcopeniaAssessment,
                                    results: SarcopeniaAssessmentModels.TestResults(gripStrengthResults: GripStrengthModels.TestResults(firstMeasurement: 14, secondMeasurement: 15,
                                                                                                                                        thirdMeasurement: 16, gender: .female),
                                                                                    calfCircumferenceResults: nil, timedUpAndGoResults: nil, walkingSpeedResults: nil))
        XCTAssertEqual(results?.1, .excellent)
        XCTAssertTrue(results?.0.isEmpty ?? true)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }
}
