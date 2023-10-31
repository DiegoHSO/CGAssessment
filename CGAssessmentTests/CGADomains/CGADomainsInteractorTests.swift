//
//  CGADomainsInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 31/10/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class CGADomainsInteractorTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?
    private var dao: CoreDataDAOMock?
    private let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3")
    private let patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3")

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

    func testControllerDidLoadWithCGA() {
        let newExpectation = expectation(description: "Call controllerDidLoad with CGA")
        currentExpectation = newExpectation

        let worker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGADomainsInteractor(presenter: self, worker: worker, patientId: patientId, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithoutCGA() {
        let newExpectation = expectation(description: "Call controllerDidLoad without CGA")
        currentExpectation = newExpectation

        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let worker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGADomainsInteractor(presenter: self, worker: worker, patientId: patientId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation, saveExpectation], timeout: 1)
    }

    func testDidSelectDomain() {
        let newExpectation = expectation(description: "Call didSelect domain")
        currentExpectation = newExpectation

        let worker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGADomainsInteractor(presenter: self, worker: worker, patientId: patientId, cgaId: cgaId)
        interactor.didSelect(domain: .cognitive)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - CGADomainsPresentationLogic extension

extension CGADomainsInteractorTests: CGADomainsPresentationLogic {
    func route(toRoute route: CGADomainsModels.Routing) {
        switch currentExpectation?.description {
        case "Call didSelect domain":
            XCTAssertEqual(route, .domainTests(domain: .cognitive, cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: CGADomainsModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad with CGA":
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Mock CGA")
            XCTAssertTrue(viewModel.domains.allSatisfy({ $0.value.allSatisfy({ $0.value })}))
        case "Call controllerDidLoad without CGA":
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Mock CGA")
            XCTAssertTrue(viewModel.domains.allSatisfy({ $0.value.allSatisfy({ !$0.value })}))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
