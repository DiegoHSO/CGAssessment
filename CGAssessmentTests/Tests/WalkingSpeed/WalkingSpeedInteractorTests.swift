//
//  WalkingSpeedInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class WalkingSpeedInteractorTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: TestExpectation?
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
        let newExpectation = TestExpectation(description: "Call controllerDidLoad")
        newExpectation.expectedFulfillmentCount = 2

        currentExpectation = newExpectation

        let worker = WalkingSpeedWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = WalkingSpeedInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapActionButtonWithoutStopwatch() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didTap action button without stopwatch")
        newExpectation.expectedFulfillmentCount = 3

        currentExpectation = newExpectation

        let worker = WalkingSpeedWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = WalkingSpeedInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidTapActionButtonWithStopwatch() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        saveExpectation.expectedFulfillmentCount = 2

        let firstExpectation = TestExpectation(description: "Call didTap action button without stopwatch")
        firstExpectation.expectedFulfillmentCount = 2

        currentExpectation = firstExpectation

        let worker = WalkingSpeedWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = WalkingSpeedInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        let secondExpectation = TestExpectation(description: "Call didTap action button with stopwatch")
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

        let newExpectation = TestExpectation(description: "Call didSelect option")
        currentExpectation = newExpectation

        let worker = WalkingSpeedWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = WalkingSpeedInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .firstOption, value: .doesNotHaveStopwatch)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidStopCounting() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        saveExpectation.expectedFulfillmentCount = 3

        let newExpectation = TestExpectation(description: "Call didStopCounting")
        newExpectation.expectedFulfillmentCount = 3

        currentExpectation = newExpectation

        let worker = WalkingSpeedWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = WalkingSpeedInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didStopCounting(elapsedTime: 12, identifier: LocalizedTable.firstMeasurement.localized)
        interactor.didStopCounting(elapsedTime: 13, identifier: LocalizedTable.secondMeasurement.localized)
        interactor.didStopCounting(elapsedTime: 14, identifier: LocalizedTable.thirdMeasurement.localized)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidChangeText() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        saveExpectation.expectedFulfillmentCount = 3

        let newExpectation = TestExpectation(description: "Call didChange text")
        newExpectation.expectedFulfillmentCount = 3

        currentExpectation = newExpectation

        let worker = WalkingSpeedWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = WalkingSpeedInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didChangeText(text: "21.48", identifier: .firstMeasurement)
        interactor.didChangeText(text: "22.19", identifier: .secondMeasurement)
        interactor.didChangeText(text: "19.81", identifier: .thirdMeasurement)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectSecondOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect second option")
        currentExpectation = newExpectation

        let worker = WalkingSpeedWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = WalkingSpeedInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .hasStopwatch)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectStopwatch() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect stopwatch")
        currentExpectation = newExpectation

        let worker = WalkingSpeedWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = WalkingSpeedInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .first)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = TestExpectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = WalkingSpeedWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = WalkingSpeedInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didSelect(option: .secondOption, value: .hasStopwatch)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidStopCountingInvalidIdentifier() {
        let newExpectation = TestExpectation(description: "Call didStopCounting invalid")
        currentExpectation = newExpectation

        let worker = WalkingSpeedWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = WalkingSpeedInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didStopCounting(elapsedTime: 23, identifier: nil)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidChangeTextInvalidIdentifier() {
        let newExpectation = TestExpectation(description: "Call didChange text invalid")
        currentExpectation = newExpectation

        let worker = WalkingSpeedWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = WalkingSpeedInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didChangeText(text: "21.1", identifier: nil)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - WalkingSpeedPresentationLogic extension

extension WalkingSpeedInteractorTests: WalkingSpeedPresentationLogic {
    func route(toRoute route: WalkingSpeedModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button without stopwatch":
            XCTAssertEqual(route, .testResults(test: .walkingSpeed, results: .init(firstElapsedTime: 13.5, secondElapsedTime: 10, thirdElapsedTime: 12), cgaId: cgaId))
        case "Call didTap action button with stopwatch":
            XCTAssertEqual(route, .testResults(test: .walkingSpeed, results: .init(firstElapsedTime: 11.4, secondElapsedTime: 14.3, thirdElapsedTime: 9.6), cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: WalkingSpeedModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button without stopwatch":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertEqual(viewModel.selectedOption, .secondOption)
            XCTAssertEqual(viewModel.typedFirstTime, Double(11.4).regionFormatted(fractionDigits: 2))
            XCTAssertEqual(viewModel.typedSecondTime, Double(14.3).regionFormatted(fractionDigits: 2))
            XCTAssertEqual(viewModel.typedThirdTime, Double(9.6).regionFormatted(fractionDigits: 2))
            XCTAssertEqual(viewModel.firstStopwatchTime, 13.5)
            XCTAssertEqual(viewModel.secondStopwatchTime, 10)
            XCTAssertEqual(viewModel.thirdStopwatchTime, 12)
            XCTAssertEqual(viewModel.selectedStopwatch, .third)
        case "Call didTap action button with stopwatch":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertEqual(viewModel.selectedOption, .firstOption)
            XCTAssertEqual(viewModel.typedFirstTime, Double(11.4).regionFormatted(fractionDigits: 2))
            XCTAssertEqual(viewModel.typedSecondTime, Double(14.3).regionFormatted(fractionDigits: 2))
            XCTAssertEqual(viewModel.typedThirdTime, Double(9.6).regionFormatted(fractionDigits: 2))
            XCTAssertEqual(viewModel.firstStopwatchTime, 13.5)
            XCTAssertEqual(viewModel.secondStopwatchTime, 10)
            XCTAssertEqual(viewModel.thirdStopwatchTime, 12)
            XCTAssertEqual(viewModel.selectedStopwatch, .third)
        case "Call didSelect option":
            XCTAssertEqual(viewModel.selectedOption, .firstOption)
        case "Call didStopCounting":
            switch currentExpectation?.currentFulfillmentCount {
            case 0:
                XCTAssertEqual(viewModel.firstStopwatchTime, 12)
                XCTAssertNil(viewModel.secondStopwatchTime)
                XCTAssertNil(viewModel.thirdStopwatchTime)
            case 1:
                XCTAssertEqual(viewModel.firstStopwatchTime, 12)
                XCTAssertEqual(viewModel.secondStopwatchTime, 13)
                XCTAssertNil(viewModel.thirdStopwatchTime)
            case 2:
                XCTAssertEqual(viewModel.firstStopwatchTime, 12)
                XCTAssertEqual(viewModel.secondStopwatchTime, 13)
                XCTAssertEqual(viewModel.thirdStopwatchTime, 14)
            default:
                XCTFail("Unexpected fullfillment count: \(currentExpectation?.currentFulfillmentCount ?? -1)")
            }
        case "Call didChange text":
            switch currentExpectation?.currentFulfillmentCount {
            case 0:
                XCTAssertEqual(viewModel.typedFirstTime, Double(21.48).regionFormatted(fractionDigits: 2))
                XCTAssertNil(viewModel.typedSecondTime)
                XCTAssertNil(viewModel.typedThirdTime)
            case 1:
                XCTAssertEqual(viewModel.typedFirstTime, Double(21.48).regionFormatted(fractionDigits: 2))
                XCTAssertEqual(viewModel.typedSecondTime, Double(22.19).regionFormatted(fractionDigits: 2))
                XCTAssertNil(viewModel.typedThirdTime)
            case 2:
                XCTAssertEqual(viewModel.typedFirstTime, Double(21.48).regionFormatted(fractionDigits: 2))
                XCTAssertEqual(viewModel.typedSecondTime, Double(22.19).regionFormatted(fractionDigits: 2))
                XCTAssertEqual(viewModel.typedThirdTime, Double(19.81).regionFormatted(fractionDigits: 2))
            default:
                XCTFail("Unexpected fullfillment count: \(currentExpectation?.currentFulfillmentCount ?? -1)")
            }
        case "Call didSelect second option":
            XCTAssertEqual(viewModel.selectedOption, .secondOption)
        case "Call didSelect stopwatch":
            XCTAssertEqual(viewModel.selectedStopwatch, .first)
        case "Call update invalid":
            XCTAssertNil(viewModel.typedFirstTime)
            XCTAssertNil(viewModel.typedSecondTime)
            XCTAssertNil(viewModel.typedThirdTime)
            XCTAssertNil(viewModel.firstStopwatchTime)
            XCTAssertNil(viewModel.secondStopwatchTime)
            XCTAssertNil(viewModel.thirdStopwatchTime)
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
