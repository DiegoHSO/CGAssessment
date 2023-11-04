//
//  WalkingSpeedWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class WalkingSpeedWorkerTests: XCTestCase {

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

        let worker = WalkingSpeedWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

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

        let worker = WalkingSpeedWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            try worker.updateWalkingSpeedProgress(with: .init(typedFirstTime: 43.21, typedSecondTime: 33.3, typedThirdTime: 12.34,
                                                              firstElapsedTime: 45.21, secondElapsedTime: 41, thirdElapsedTime: 12,
                                                              selectedOption: .firstOption, selectedStopwatch: .first, isDone: false))
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }
}
