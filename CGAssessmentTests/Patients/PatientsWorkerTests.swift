//
//  PatientsWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 31/10/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class PatientsWorkerTests: XCTestCase {

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

    func testGetPatients() {
        let newExpectation = expectation(description: "Call getPatients")
        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        guard let patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        do {
            let patients = try worker.getPatients()
            XCTAssertEqual(patients.count, 1)
            XCTAssertEqual(patients.first?.name, "Mock CGA")
            XCTAssertEqual(patients.first?.patientId, patientId)
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testDeletePatient() {
        let newExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }
        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        guard let patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        do {
            try worker.deletePatient(patientId: patientId)
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

}
