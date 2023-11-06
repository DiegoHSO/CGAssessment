//
//  VerbalFluencyInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class VerbalFluencyInteractorTests: XCTestCase {

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
        newExpectation.expectedFulfillmentCount = 2

        currentExpectation = newExpectation

        let worker = VerbalFluencyWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = VerbalFluencyInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapActionButton() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call didTap action button")
        newExpectation.expectedFulfillmentCount = 3

        currentExpectation = newExpectation

        let worker = VerbalFluencyWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = VerbalFluencyInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call didSelect option")
        currentExpectation = newExpectation

        let worker = VerbalFluencyWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = VerbalFluencyInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .none, value: .none)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidStopCounting() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call didStopCounting")
        currentExpectation = newExpectation

        let worker = VerbalFluencyWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = VerbalFluencyInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didStopCounting(elapsedTime: 22, identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidUpdateCountedWords() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let worker = VerbalFluencyWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = VerbalFluencyInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didChangeValue(value: 14)

        wait(for: [saveExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = expectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = VerbalFluencyWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = VerbalFluencyInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didSelect(option: .secondOption, value: .hasStopwatch)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - VerbalFluencyPresentationLogic extension

extension VerbalFluencyInteractorTests: VerbalFluencyPresentationLogic {
    func route(toRoute route: VerbalFluencyModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .verbalFluencyTest, results: .init(countedWords: 19, selectedEducationOption: .firstOption), cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: VerbalFluencyModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertEqual(viewModel.elapsedTime, 12.5)
            XCTAssertEqual(viewModel.selectedOption, .firstOption)
            XCTAssertEqual(viewModel.countedWords, 19)
        case "Call didSelect option":
            XCTAssertEqual(viewModel.selectedOption, .none)
        case "Call didStopCounting":
            XCTAssertEqual(viewModel.elapsedTime, 22)
        case "Call update invalid":
            XCTAssertEqual(viewModel.countedWords, 0)
            XCTAssertEqual(viewModel.elapsedTime, 60)
            XCTAssertEqual(viewModel.selectedOption, .secondOption)
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
