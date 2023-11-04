//
//  PatientsInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 31/10/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class PatientsInteractorTests: XCTestCase {

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

    func testControllerDidLoad() {
        let newExpectation = expectation(description: "Call controllerDidLoad")
        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = PatientsInteractor(presenter: self, worker: worker)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidChangeSearchText() {
        let didLoadExpectation = expectation(description: "Call controllerDidLoad")
        currentExpectation = didLoadExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = PatientsInteractor(presenter: self, worker: worker)
        interactor.controllerDidLoad()

        let didChangeExpectation = expectation(description: "Call didChange searchText")
        currentExpectation = didChangeExpectation

        interactor.didChange(searchText: "Invalid name")

        wait(for: [didLoadExpectation, didChangeExpectation], timeout: 1)
    }

    func testDidTapToStartNewCGA() {
        let newExpectation = expectation(description: "Call didTapToStartNewCGA")
        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = PatientsInteractor(presenter: self, worker: worker)
        interactor.didTapToStartNewCGA()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidConfirmDeletion() {
        let newExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = PatientsInteractor(presenter: self, worker: worker)
        interactor.didConfirmDeletion(for: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectPatient() {
        let newExpectation = expectation(description: "Call didSelect Patient")
        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = PatientsInteractor(presenter: self, worker: worker)
        interactor.didSelect(patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSwipeToDelete() {
        let newExpectation = expectation(description: "Call didSwipeToDelete")
        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = PatientsInteractor(presenter: self, worker: worker)
        interactor.didSwipeToDelete(indexPath: IndexPath(row: 0, section: 0))

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectAToZFilter() {
        let newExpectation = expectation(description: "Call didSelect AToZ Filter")
        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = PatientsInteractor(presenter: self, worker: worker)
        interactor.didSelect(filterOption: .aToZ)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectByPatientFilter() {
        let newExpectation = expectation(description: "Call didSelect byPatient Filter")
        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = PatientsInteractor(presenter: self, worker: worker)
        interactor.didSelect(filterOption: .byPatient)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectOlderFilter() {
        let newExpectation = expectation(description: "Call didSelect older Filter")
        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = PatientsInteractor(presenter: self, worker: worker)
        interactor.didSelect(filterOption: .older)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectOlderAgeFilter() {
        let newExpectation = expectation(description: "Call didSelect olderAge Filter")
        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = PatientsInteractor(presenter: self, worker: worker)
        interactor.didSelect(filterOption: .olderAge)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectRecentFilter() {
        let newExpectation = expectation(description: "Call didSelect recent Filter")
        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = PatientsInteractor(presenter: self, worker: worker)
        interactor.didSelect(filterOption: .recent)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectYoungerAgeFilter() {
        let newExpectation = expectation(description: "Call didSelect youngerAge Filter")

        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = PatientsInteractor(presenter: self, worker: worker)
        interactor.didSelect(filterOption: .youngerAge)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectZToAFilter() {
        let newExpectation = expectation(description: "Call didSelect ZToA Filter")
        currentExpectation = newExpectation

        let worker = PatientsWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = PatientsInteractor(presenter: self, worker: worker)
        interactor.didSelect(filterOption: .zToA)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - PatientsPresentationLogic extension

extension PatientsInteractorTests: PatientsPresentationLogic {
    func route(toRoute route: PatientsModels.Routing) {
        switch currentExpectation?.description {
        case "Call didTapToStartNewCGA":
            XCTAssertEqual(route, .newCGA)
        case "Call didSelect Patient":
            XCTAssertEqual(route, .cgas(patientId: UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3")))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: PatientsModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad":
            XCTAssertEqual(viewModel.selectedFilter, .aToZ)
            XCTAssertEqual(viewModel.patients.first?.name, "Mock CGA")
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
        case "Call didChange searchText":
            XCTAssertTrue(viewModel.isSearching)
            XCTAssertTrue(viewModel.patients.isEmpty)
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
