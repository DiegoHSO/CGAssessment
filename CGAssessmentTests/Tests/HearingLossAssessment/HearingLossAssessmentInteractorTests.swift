//
//  HearingLossAssessmentInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 03/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class HearingLossAssessmentInteractorTests: XCTestCase {

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

        currentExpectation = newExpectation

        let worker = HearingLossAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = HearingLossAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapActionButton() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didTap action button")
        newExpectation.expectedFulfillmentCount = 2

        currentExpectation = newExpectation

        let worker = HearingLossAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = HearingLossAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = TestExpectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = HearingLossAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = HearingLossAssessmentInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didTapActionButton(identifier: nil)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - HearingLossAssessmentPresentationLogic extension

extension HearingLossAssessmentInteractorTests: HearingLossAssessmentPresentationLogic {
    func route(toRoute route: HearingLossAssessmentModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .katzScale(cgaId: cgaId))
        case "Call update invalid":
            if case HearingLossAssessmentModels.Routing.katzScale = route {
                break
            }
            return
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: HearingLossAssessmentModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button", "Call update invalid":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
