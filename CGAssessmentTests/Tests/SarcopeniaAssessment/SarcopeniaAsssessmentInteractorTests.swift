//
//  SarcopeniaAssessmentInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class SarcopeniaAssessmentInteractorTests: XCTestCase {

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

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SarcopeniaAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadInvalid() {
        let newExpectation = TestExpectation(description: "Call controllerDidLoad invalid")

        currentExpectation = newExpectation

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: nil)

        let interactor = SarcopeniaAssessmentInteractor(presenter: self, worker: worker, cgaId: nil)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapActionButton() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didTap action button")
        newExpectation.expectedFulfillmentCount = 3

        currentExpectation = newExpectation

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SarcopeniaAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectGripStrength() {
        let newExpectation = TestExpectation(description: "Call didSelect GripStrength")

        currentExpectation = newExpectation

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SarcopeniaAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(test: .gripStrength)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectCalfCircumference() {
        let newExpectation = TestExpectation(description: "Call didSelect CalfCircumference")

        currentExpectation = newExpectation

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SarcopeniaAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(test: .calfCircumference)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectTimedUpAndGo() {
        let newExpectation = TestExpectation(description: "Call didSelect TimedUpAndGo")

        currentExpectation = newExpectation

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SarcopeniaAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(test: .timedUpAndGo)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectWalkingSpeed() {
        let newExpectation = TestExpectation(description: "Call didSelect WalkingSpeed")

        currentExpectation = newExpectation

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SarcopeniaAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(test: .walkingSpeed)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectInvalidTest() {
        let newExpectation = TestExpectation(description: "Call didSelect invalid test")

        currentExpectation = newExpectation

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SarcopeniaAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(test: .moca)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testUpdateInvalid() {
        let newExpectation = TestExpectation(description: "Call update invalid")

        currentExpectation = newExpectation

        let worker = SarcopeniaAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = SarcopeniaAssessmentInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didTapActionButton(identifier: nil)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

}

// MARK: - SarcopeniaAssessmentPresentationLogic extension

extension SarcopeniaAssessmentInteractorTests: SarcopeniaAssessmentPresentationLogic {
    func route(toRoute route: SarcopeniaAssessmentModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .sarcopeniaAssessment, results: .init(gripStrengthResults: .init(firstMeasurement: 27, secondMeasurement: 26,
                                                                                                                      thirdMeasurement: 27.5, gender: .female),
                                                                                           calfCircumferenceResults: .init(circumference: 31.3),
                                                                                           timedUpAndGoResults: .init(elapsedTime: 8.56),
                                                                                           walkingSpeedResults: .init(firstElapsedTime: 13.5, secondElapsedTime: 10,
                                                                                                                      thirdElapsedTime: 12)), cgaId: cgaId))
        case "Call didSelect GripStrength":
            XCTAssertEqual(route, .gripStrength(cgaId: cgaId))
        case "Call didSelect CalfCircumference":
            XCTAssertEqual(route, .calfCircumference(cgaId: cgaId))
        case "Call didSelect TimedUpAndGo":
            XCTAssertEqual(route, .timedUpAndGo(cgaId: cgaId))
        case "Call didSelect WalkingSpeed":
            XCTAssertEqual(route, .walkingSpeed(cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: SarcopeniaAssessmentModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertTrue(viewModel.testsCompletionStatus.allSatisfy { $0.value == .done })
        case "Call controllerDidLoad invalid":
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            XCTAssertFalse(viewModel.testsCompletionStatus.allSatisfy { $0.value == .done })
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
