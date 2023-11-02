//
//  CalfCircumferenceInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class CalfCircumferenceInteractorTests: XCTestCase {

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

        let worker = CalfCircumferenceWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = CalfCircumferenceInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = CalfCircumferenceWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = CalfCircumferenceInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = CalfCircumferenceWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = CalfCircumferenceInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didChangeText(text: "21.42", identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = expectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = CalfCircumferenceWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = CalfCircumferenceInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didChangeText(text: "-232.1", identifier: nil)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - CalfCircumferencePresentationLogic extension

extension CalfCircumferenceInteractorTests: CalfCircumferencePresentationLogic {
    func route(toRoute route: CalfCircumferenceModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .calfCircumference, results: .init(circumference: 31.3), cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: CalfCircumferenceModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertEqual(viewModel.typedCircumference, Double(31.3).regionFormatted(fractionDigits: 2))
        case "Call didChange text":
            XCTAssertEqual(viewModel.typedCircumference, Double(21.42).regionFormatted(fractionDigits: 2))
        case "Call update invalid":
            XCTAssertEqual(viewModel.typedCircumference, Double(-232.1).regionFormatted(fractionDigits: 2))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
