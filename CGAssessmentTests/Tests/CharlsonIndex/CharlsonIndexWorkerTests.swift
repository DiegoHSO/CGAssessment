//
//  CharlsonIndexWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class CharlsonIndexWorkerTests: XCTestCase {

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

        let worker = CharlsonIndexWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let test = try worker.getCharlsonIndexProgress()

            guard let binaryOptions = test?.binaryOptions?.allObjects as? [BinaryOption] else {
                XCTFail("Unable to get selectable options for test")
                return
            }

            var rawBinaryQuestions: CharlsonIndexModels.RawBinaryQuestions = [:]

            binaryOptions.forEach { option in
                guard let selectedOption = SelectableBinaryKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.sectionId ?? "") else { return }
                if rawBinaryQuestions[identifier] == nil { rawBinaryQuestions[identifier] = [:] }
                rawBinaryQuestions[identifier]?.updateValue(selectedOption, forKey: option.optionId)
            }

            XCTAssertEqual(rawBinaryQuestions, [
                .charlsonIndexMainQuestion: [1: .yes, 2: .not, 3: .yes, 4: .not, 5: .not, 6: .not,
                                             7: .not, 8: .not, 9: .not, 10: .not, 11: .not, 12: .not,
                                             13: .not, 14: .not, 15: .not, 16: .not, 17: .not, 18: .not]
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

        let worker = CharlsonIndexWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            try worker.updateCharlsonIndexProgress(with: .init(binaryQuestions: [
                .charlsonIndexMainQuestion: [1: .not, 2: .not, 3: .yes, 4: .yes, 5: .not, 6: .not,
                                             7: .yes, 8: .yes, 9: .yes, 10: .not, 11: .not, 12: .not,
                                             13: .yes, 14: .yes, 15: .not, 16: .not, 17: .not, 18: .not]
            ], isDone: false))
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testGetPatientAge() {
        let newExpectation = expectation(description: "Call getPatientAge")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = CharlsonIndexWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let birthDate = try worker.getPatientBirthDate()
            XCTAssertEqual(birthDate, Date().addingYear(-75).removingTimeComponents())
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetInvalidPatientAge() {
        let newExpectation = expectation(description: "Call getPatientAge invalid")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "1734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = CharlsonIndexWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            _ = try worker.getPatientBirthDate()
        } catch {
            currentExpectation?.fulfill()
        }

        wait(for: [newExpectation], timeout: 1)
    }
}
