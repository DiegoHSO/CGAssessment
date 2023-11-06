//
//  TimedUpAndGoInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class TimedUpAndGoInteractorTests: XCTestCase {

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

        let worker = TimedUpAndGoWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = TimedUpAndGoInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapActionButtonWithoutStopwatch() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call didTap action button without stopwatch")
        newExpectation.expectedFulfillmentCount = 3

        currentExpectation = newExpectation

        let worker = TimedUpAndGoWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = TimedUpAndGoInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidTapActionButtonWithStopwatch() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        saveExpectation.expectedFulfillmentCount = 2

        let firstExpectation = expectation(description: "Call didTap action button without stopwatch")
        firstExpectation.expectedFulfillmentCount = 2

        currentExpectation = firstExpectation

        let worker = TimedUpAndGoWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = TimedUpAndGoInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        let secondExpectation = expectation(description: "Call didTap action button with stopwatch")
        secondExpectation.expectedFulfillmentCount = 2

        currentExpectation = secondExpectation

        interactor.didSelect(option: .firstOption, value: .hasStopwatch)
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, firstExpectation, secondExpectation], timeout: 1)
    }

    func testDidSelectOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call didSelect option")
        currentExpectation = newExpectation

        let worker = TimedUpAndGoWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = TimedUpAndGoInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .firstOption, value: .doesNotHaveStopwatch)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidStopCounting() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call didStopCounting")
        currentExpectation = newExpectation

        let worker = TimedUpAndGoWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = TimedUpAndGoInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didStopCounting(elapsedTime: 12, identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidChangeText() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call didChange text")
        currentExpectation = newExpectation

        let worker = TimedUpAndGoWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = TimedUpAndGoInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didChangeText(text: "21.42", identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectSecondOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call didSelect second option")
        currentExpectation = newExpectation

        let worker = TimedUpAndGoWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = TimedUpAndGoInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .hasStopwatch)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = expectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = TimedUpAndGoWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = TimedUpAndGoInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didSelect(option: .secondOption, value: .hasStopwatch)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - TimedUpAndGoPresentationLogic extension

extension TimedUpAndGoInteractorTests: TimedUpAndGoPresentationLogic {
    func route(toRoute route: TimedUpAndGoModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button without stopwatch":
            XCTAssertEqual(route, .testResults(test: .timedUpAndGo, results: .init(elapsedTime: 8.56), cgaId: cgaId))
        case "Call didTap action button with stopwatch":
            XCTAssertEqual(route, .testResults(test: .timedUpAndGo, results: .init(elapsedTime: 9.25), cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: TimedUpAndGoModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button without stopwatch":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertEqual(viewModel.selectedOption, .secondOption)
            XCTAssertEqual(viewModel.typedElapsedTime, Double(9.25).regionFormatted(fractionDigits: 2))
            XCTAssertEqual(viewModel.stopwatchElapsedTime, 8.56)
        case "Call didTap action button with stopwatch":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertEqual(viewModel.selectedOption, .firstOption)
            XCTAssertEqual(viewModel.typedElapsedTime, Double(9.25).regionFormatted(fractionDigits: 2))
            XCTAssertEqual(viewModel.stopwatchElapsedTime, 8.56)
        case "Call didSelect option":
            XCTAssertEqual(viewModel.selectedOption, .firstOption)
        case "Call didStopCounting":
            XCTAssertEqual(viewModel.stopwatchElapsedTime, 12)
        case "Call didChange text":
            XCTAssertEqual(viewModel.typedElapsedTime, Double(21.42).regionFormatted(fractionDigits: 2))
        case "Call didSelect second option":
            XCTAssertEqual(viewModel.selectedOption, .secondOption)
        case "Call update invalid":
            XCTAssertNil(viewModel.stopwatchElapsedTime)
            XCTAssertNil(viewModel.typedElapsedTime)
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
