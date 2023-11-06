//
//  SuspectedAbuseInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class SuspectedAbuseInteractorTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?
    private var dao: CoreDataDAOMock?
    private let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3")

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

        let worker = SuspectedAbuseWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SuspectedAbuseInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapActionButton() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call didTap action button")
        newExpectation.expectedFulfillmentCount = 2

        currentExpectation = newExpectation

        let worker = SuspectedAbuseWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SuspectedAbuseInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidChangeText() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call didChange text")
        currentExpectation = newExpectation

        let worker = SuspectedAbuseWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SuspectedAbuseInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didChangeText(text: "Psycho abuse", identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectFirstOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call didSelect first option")
        currentExpectation = newExpectation

        let worker = SuspectedAbuseWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SuspectedAbuseInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .firstOption, value: .yesKey)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectSecondOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call didSelect second option")
        currentExpectation = newExpectation

        let worker = SuspectedAbuseWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SuspectedAbuseInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .noKey)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectNoOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call didSelect no option")
        currentExpectation = newExpectation

        let worker = SuspectedAbuseWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SuspectedAbuseInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .none, value: .none)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = expectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = SuspectedAbuseWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = SuspectedAbuseInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didChangeText(text: "Test abuse", identifier: nil)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - SuspectedAbusePresentationLogic extension

extension SuspectedAbuseInteractorTests: SuspectedAbusePresentationLogic {
    func route(toRoute route: SuspectedAbuseModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .chemotherapyToxicityRisk(cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: SuspectedAbuseModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertEqual(viewModel.selectedOption, .firstOption)
            XCTAssertEqual(viewModel.textViewModel.text, LocalizedTable.suspectedAbuseExample.localized)
        case "Call didChange text":
            XCTAssertEqual(viewModel.textViewModel.text, "Psycho abuse")
        case "Call update invalid":
            XCTAssertEqual(viewModel.textViewModel.text, "Test abuse")
        case "Call didSelect first option":
            XCTAssertEqual(viewModel.selectedOption, .firstOption)
        case "Call didSelect second option":
            XCTAssertEqual(viewModel.selectedOption, .secondOption)
        case "Call didSelect no option":
            XCTAssertEqual(viewModel.selectedOption, .none)
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
