//
//  NewCGAWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 30/10/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class NewCGAWorkerTests: XCTestCase {

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

    func testGetAllPatients() {
        let newExpectation = expectation(description: "Call getAllPatients")
        currentExpectation = newExpectation

        let worker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)

        guard let patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        do {
            let patients = try worker.getAllPatients()
            XCTAssertEqual(patients.count, 1)
            XCTAssertEqual(patients.first?.patientId, patientId)
            XCTAssertEqual(patients.first?.name, "Mock CGA")
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testSavePatient() {
        let newExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }
        currentExpectation = newExpectation

        let worker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)

        do {
            let uuid = try worker.savePatient(patientData: .init(patientName: "Test Patient", birthDate: Date().addingYear(-97), gender: .female))
            XCTAssertNotNil(uuid)
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

}
