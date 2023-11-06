//
//  NewCGAInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 30/10/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class NewCGAInteractorTests: XCTestCase {

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

        let worker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = NewCGAInteractor(presenter: self, worker: worker)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidChangeSearchText() {
        let didLoadExpectation = expectation(description: "Call controllerDidLoad")
        currentExpectation = didLoadExpectation

        let worker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = NewCGAInteractor(presenter: self, worker: worker)
        interactor.controllerDidLoad()

        let didChangeExpectation = expectation(description: "Call didChange searchText")
        currentExpectation = didChangeExpectation

        interactor.didChange(searchText: "Invalid name")

        wait(for: [didLoadExpectation, didChangeExpectation], timeout: 1)
    }

    func testDidChangeText() {
        let newExpectation = expectation(description: "Call didChange text")
        currentExpectation = newExpectation

        let worker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = NewCGAInteractor(presenter: self, worker: worker)
        interactor.didChangeText(text: "New test Patient", identifier: nil)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectNoOption() {
        let newExpectation = expectation(description: "Call didSelect noOption")
        currentExpectation = newExpectation

        let worker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = NewCGAInteractor(presenter: self, worker: worker)
        interactor.didSelect(option: .firstOption, value: .noKey)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectYesOption() {
        let newExpectation = expectation(description: "Call didSelect yesOption")
        currentExpectation = newExpectation

        let worker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = NewCGAInteractor(presenter: self, worker: worker)
        interactor.didSelect(option: .secondOption, value: .yesKey)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectGender() {
        let newExpectation = expectation(description: "Call didSelect gender")
        currentExpectation = newExpectation

        let worker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = NewCGAInteractor(presenter: self, worker: worker)
        interactor.didSelect(option: .secondOption, value: .gender)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectPatient() {
        let newExpectation = expectation(description: "Call didSelect patient")
        currentExpectation = newExpectation

        let worker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = NewCGAInteractor(presenter: self, worker: worker)

        guard let patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        interactor.didSelect(patientId: patientId)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectDate() {
        let newExpectation = expectation(description: "Call didSelect date")
        currentExpectation = newExpectation

        let worker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = NewCGAInteractor(presenter: self, worker: worker)
        interactor.didSelectDate(date: Date().addingYear(-87))

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapSaveNewPatient() {
        let newExpectation = expectation(description: "Call didTapSave new patient")
        newExpectation.expectedFulfillmentCount = 4

        currentExpectation = newExpectation

        let worker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = NewCGAInteractor(presenter: self, worker: worker)
        interactor.didSelect(option: .firstOption, value: .noKey)
        interactor.didChangeText(text: "Test Patient", identifier: nil)
        interactor.didSelectDate(date: Date().addingYear(-63))
        interactor.didSelect(option: .firstOption, value: .gender)

        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        currentExpectation = saveExpectation

        interactor.didTapActionButton(identifier: nil)

        wait(for: [newExpectation, saveExpectation], timeout: 1)

    }

    func testDidTapSaveOldPatient() {
        let newExpectation = expectation(description: "Call didTapSave old patient")

        currentExpectation = newExpectation
        newExpectation.expectedFulfillmentCount = 2

        let worker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = NewCGAInteractor(presenter: self, worker: worker)

        guard let patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        interactor.didSelect(option: .secondOption, value: .yesKey)
        interactor.didSelect(patientId: patientId)

        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        currentExpectation = saveExpectation

        interactor.didTapActionButton(identifier: nil)

        wait(for: [newExpectation, saveExpectation], timeout: 1)
    }
}

// MARK: - NewCGAPresentationLogic extension

extension NewCGAInteractorTests: NewCGAPresentationLogic {
    func route(toRoute route: NewCGAModels.Routing) {
        if let expectationDescription = currentExpectation?.description,
           expectationDescription.contains("Expect notification 'NSManagingContextDidSaveChangesNotification' from"),
           case NewCGAModels.Routing.cgaDomains = route {
            currentExpectation?.fulfill()
        } else {
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: NewCGAModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call didTapSave new patient", "Call didTapSave old patient":
            break
        case "Call controllerDidLoad":
            XCTAssertEqual(viewModel.selectedExternalOption, .secondOption)
            XCTAssertEqual(viewModel.patients.first?.id, UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        case "Call didChange searchText":
            XCTAssertTrue(viewModel.isSearching)
            XCTAssertTrue(viewModel.patients.isEmpty)
        case "Call didChange text":
            XCTAssertEqual(viewModel.patientName, "New test Patient")
        case "Call didSelect noOption":
            XCTAssertEqual(viewModel.selectedExternalOption, .firstOption)
        case "Call didSelect yesOption":
            XCTAssertEqual(viewModel.selectedExternalOption, .secondOption)
        case "Call didSelect gender":
            XCTAssertEqual(viewModel.selectedInternalOption, .secondOption)
        case "Call didSelect patient":
            XCTAssertEqual(viewModel.selectedPatient, UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3"))
        case "Call didSelect date":
            break
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentAlert() {
        XCTFail("Should not have been called: \(#function)")
    }
}
