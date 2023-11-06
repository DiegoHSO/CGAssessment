//
//  ClockDrawingWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 02/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class ClockDrawingWorkerTests: XCTestCase {

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

    func testGetAssessmentProgress() {
        let newExpectation = expectation(description: "Call getAssessmentProgress")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = ClockDrawingWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let test = try worker.getClockDrawingProgress()

            guard let binaryOptions = test?.binaryOptions?.allObjects as? [BinaryOption] else {
                XCTFail("Unable to get selectable options for test")
                return
            }

            var rawBinaryQuestions: ClockDrawingModels.RawBinaryQuestions = [:]

            binaryOptions.forEach { option in
                guard let selectedOption = SelectableBinaryKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.sectionId ?? "") else { return }
                if rawBinaryQuestions[identifier] == nil { rawBinaryQuestions[identifier] = [:] }
                rawBinaryQuestions[identifier]?.updateValue(selectedOption, forKey: option.optionId)
            }

            XCTAssertEqual(rawBinaryQuestions, [
                .outline: [1: .yes, 2: .yes],
                .numbers: [1: .yes, 2: .not, 3: .yes, 4: .not, 5: .yes, 6: .yes],
                .pointers: [1: .not, 2: .yes, 3: .yes, 4: .yes, 5: .not, 6: .yes]
            ])

            XCTAssertEqual(test?.isDone, true)
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testSaveAssessmentProgress() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call saveAssessmentProgress")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = ClockDrawingWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            try worker.updateClockDrawingProgress(with: .init(binaryQuestions: [
                .outline: [1: .not, 2: .not],
                .numbers: [1: .not, 2: .yes, 3: .yes, 4: .not, 5: .yes, 6: .yes],
                .pointers: [1: .yes, 2: .not, 3: .yes, 4: .yes, 5: .not, 6: .not]
            ], isDone: false))
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }
}
