//
//  DashboardWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 29/10/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class DashboardWorkerTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?
    private var dao: CoreDataDAOProtocol?

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

    func testGetClosestCGAs() {
        let newExpectation = expectation(description: "Call getClosestCGAs")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3"),
              let patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        do {
            let cgas = try worker.getClosestCGAs()
            XCTAssertEqual(cgas.count, 1)
            XCTAssertEqual(cgas.first?.cgaId, cgaId)
            XCTAssertEqual(cgas.first?.patient?.patientId, patientId)
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetLatestCGA() {
        let newExpectation = expectation(description: "Call getLatestCGA")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3"),
              let patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        do {
            let cga = try worker.getLatestCGA()
            XCTAssertEqual(cga?.cgaId, cgaId)
            XCTAssertEqual(cga?.patient?.patientId, patientId)
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

}
