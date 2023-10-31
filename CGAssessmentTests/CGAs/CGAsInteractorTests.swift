//
//  CGAsInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 30/10/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class CGAsInteractorTests: XCTestCase {

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

    func testControllerDidLoadWithPatient() {
        let newExpectation = expectation(description: "Call controllerDidLoad with patient")
        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithoutPatient() {
        let newExpectation = expectation(description: "Call controllerDidLoad without patient")
        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: nil)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerWillDisappear() {
        let newExpectation = expectation(description: "Call controllerWillDisappear")
        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        interactor.controllerWillDisappear()

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToStartNewCGA() {
        let newExpectation = expectation(description: "Call didTapToStartNewCGA")
        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        interactor.didTapToStartNewCGA()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidConfirmDeletion() {
        let newExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        interactor.didConfirmDeletion(for: UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3"))

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectCGA() {
        let newExpectation = expectation(description: "Call didSelect CGA")
        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        interactor.didSelect(cgaId: UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3"))

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSwipeToDelete() {
        let newExpectation = expectation(description: "Call didSwipeToDelete")
        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        interactor.didSwipeToDelete(indexPath: IndexPath(row: 0, section: 0))

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectAToZFilter() {
        let newExpectation = expectation(description: "Call didSelect AToZ Filter")
        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        interactor.didSelect(filterOption: .aToZ)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectByPatientFilter() {
        let newExpectation = expectation(description: "Call didSelect byPatient Filter")
        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        interactor.didSelect(filterOption: .byPatient)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectOlderFilter() {
        let newExpectation = expectation(description: "Call didSelect older Filter")
        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        interactor.didSelect(filterOption: .older)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectOlderAgeFilter() {
        let newExpectation = expectation(description: "Call didSelect olderAge Filter")
        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        interactor.didSelect(filterOption: .olderAge)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectRecentFilter() {
        let newExpectation = expectation(description: "Call didSelect recent Filter")
        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        interactor.didSelect(filterOption: .recent)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectYoungerAgeFilter() {
        let newExpectation = expectation(description: "Call didSelect youngerAge Filter")

        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        interactor.didSelect(filterOption: .youngerAge)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectZToAFilter() {
        let newExpectation = expectation(description: "Call didSelect ZToA Filter")
        currentExpectation = newExpectation

        let worker = CGAsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = CGAsInteractor(presenter: self, worker: worker, patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        interactor.didSelect(filterOption: .zToA)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - CGAsPresentationLogic extension

extension CGAsInteractorTests: CGAsPresentationLogic {
    func route(toRoute route: CGAsModels.Routing) {
        switch currentExpectation?.description {
        case "Call didTapToStartNewCGA":
            XCTAssertEqual(route, .newCGA)
        case "Call didSelect CGA":
            XCTAssertEqual(route, .cgaDomains(cgaId: UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3")))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: CGAsModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad with patient":
            XCTAssertEqual(viewModel.selectedFilter, .recent)
            XCTAssertEqual(viewModel.patientName, "Mock CGA")
        case "Call controllerDidLoad without patient":
            XCTAssertEqual(viewModel.selectedFilter, .recent)
            XCTAssertEqual(viewModel.patientName, nil)
        case "Call didSelect AToZ Filter":
            XCTAssertEqual(viewModel.selectedFilter, .aToZ)
        case "Call didSelect byPatient Filter":
            XCTAssertEqual(viewModel.selectedFilter, .byPatient)
        case "Call didSelect older Filter":
            XCTAssertEqual(viewModel.selectedFilter, .older)
        case "Call didSelect olderAge Filter":
            XCTAssertEqual(viewModel.selectedFilter, .olderAge)
        case "Call didSelect recent Filter":
            XCTAssertEqual(viewModel.selectedFilter, .recent)
        case "Call didSelect youngerAge Filter":
            XCTAssertEqual(viewModel.selectedFilter, .youngerAge)
        case "Call didSelect ZToA Filter":
            XCTAssertEqual(viewModel.selectedFilter, .zToA)
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentDeletionAlert(for indexPath: IndexPath) {
        XCTAssertEqual(currentExpectation?.description, "Call didSwipeToDelete")
        XCTAssertEqual(indexPath, IndexPath(row: 0, section: 0))
        currentExpectation?.fulfill()
    }

    func presentErrorDeletingAlert() {
        XCTFail("Should not have been called: \(#function)")
    }
}
