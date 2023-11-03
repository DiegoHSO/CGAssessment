//
//  SarcopeniaAssessmentWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class SarcopeniaAssessmentWorkerTests: XCTestCase {

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

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let test = try worker.getSarcopeniaAssessmentProgress()
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

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            try worker.updateSarcopeniaAssessmentProgress(with: .init(isDone: false))
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testGetGripStrengthProgress() {
        let newExpectation = expectation(description: "Call getGripStrengthProgress")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let test = try worker.getGripStrengthProgress()
            XCTAssertEqual(test?.firstMeasurement, 27)
            XCTAssertEqual(test?.secondMeasurement, 26)
            XCTAssertEqual(test?.thirdMeasurement, 27.5)
            XCTAssertEqual(test?.isDone, true)
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetCalfCircumferenceProgress() {
        let newExpectation = expectation(description: "Call getCalfCircumferenceProgress")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let test = try worker.getCalfCircumferenceProgress()
            XCTAssertEqual(test?.measuredCircumference, 31.3)
            XCTAssertEqual(test?.isDone, true)
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetTimedUpAndGoProgress() {
        let newExpectation = expectation(description: "Call getTimedUpAndGoProgress")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let test = try worker.getTimedUpAndGoProgress()
            XCTAssertEqual(test?.hasStopwatch, false)
            XCTAssertEqual(test?.typedTime, 9.25)
            XCTAssertEqual(test?.measuredTime, 8.56)
            XCTAssertEqual(test?.isDone, true)
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetWalkingSpeedProgress() {
        let newExpectation = expectation(description: "Call getWalkingSpeedProgress")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let test = try worker.getWalkingSpeedProgress()
            XCTAssertEqual(test?.hasStopwatch, false)
            XCTAssertEqual(test?.selectedStopwatch, 3)
            XCTAssertEqual(test?.firstTypedTime, 11.4)
            XCTAssertEqual(test?.secondTypedTime, 14.3)
            XCTAssertEqual(test?.thirdTypedTime, 9.6)
            XCTAssertEqual(test?.firstMeasuredTime, 13.5)
            XCTAssertEqual(test?.secondMeasuredTime, 10)
            XCTAssertEqual(test?.thirdMeasuredTime, 12)
            XCTAssertEqual(test?.isDone, true)
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetPatientGender() {
        let newExpectation = expectation(description: "Call getPatientGender")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let gender = try worker.getPatientGender()
            XCTAssertEqual(gender, .female)
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetInvalidPatientGender() {
        let newExpectation = expectation(description: "Call getPatientGender invalid")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "1734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            _ = try worker.getPatientGender()
        } catch {
            currentExpectation?.fulfill()
        }

        wait(for: [newExpectation], timeout: 1)
    }
}
