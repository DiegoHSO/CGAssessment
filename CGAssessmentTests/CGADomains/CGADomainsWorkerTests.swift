//
//  CGADomainsWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 31/10/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class CGADomainsWorkerTests: XCTestCase {

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

    func testGetCGADomains() {
        let newExpectation = expectation(description: "Call getCGADomains")
        currentExpectation = newExpectation

        let worker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        do {
            let cga = try worker.getCGA(with: cgaId)
            XCTAssertEqual(cga.cgaId, cgaId)
            XCTAssertEqual(cga.patient?.name, "Mock CGA")
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testGetInvalidCGA() {
        let newExpectation = expectation(description: "Call getInvalidCGA")
        currentExpectation = newExpectation

        let worker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        guard let cgaId = UUID(uuidString: "1334772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        do {
            _ = try worker.getCGA(with: cgaId)
        } catch {
            currentExpectation?.fulfill()
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testSaveCGA() {
        let newExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        currentExpectation = newExpectation

        let worker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        guard let patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        do {
            let uuid = try worker.saveCGA(for: patientId)
            XCTAssertNotNil(uuid)
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testSaveInvalidCGA() {
        let newExpectation = expectation(description: "Call saveInvalidCGA")

        currentExpectation = newExpectation

        let worker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        guard let patientId = UUID(uuidString: "1334772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        do {
            _ = try worker.saveCGA(for: patientId)
        } catch {
            currentExpectation?.fulfill()
        }

        wait(for: [newExpectation], timeout: 1)
    }

}
