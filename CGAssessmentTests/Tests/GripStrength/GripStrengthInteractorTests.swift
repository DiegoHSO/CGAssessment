//
//  GripStrengthInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class GripStrengthInteractorTests: XCTestCase {

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

        let worker = GripStrengthWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = GripStrengthInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = GripStrengthWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = GripStrengthInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()
        interactor.didTapActionButton(identifier: nil)

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

        let worker = GripStrengthWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = GripStrengthInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didChangeText(text: "21.48", identifier: .firstMeasurement)
        interactor.didChangeText(text: "22.19", identifier: .secondMeasurement)
        interactor.didChangeText(text: "19.81", identifier: .thirdMeasurement)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = TestExpectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = GripStrengthWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = GripStrengthInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didChangeText(text: "12.l", identifier: .firstMeasurement)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidChangeTextInvalidIdentifier() {
        let newExpectation = TestExpectation(description: "Call didChange text invalid")
        currentExpectation = newExpectation

        let worker = GripStrengthWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = GripStrengthInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didChangeText(text: "21.1", identifier: nil)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - GripStrengthPresentationLogic extension

extension GripStrengthInteractorTests: GripStrengthPresentationLogic {
    func route(toRoute route: GripStrengthModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .gripStrength, results: .init(firstMeasurement: 27, secondMeasurement: 26, thirdMeasurement: 27.5, gender: .female), cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: GripStrengthModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertEqual(viewModel.typedFirstMeasurement, Double(27).regionFormatted(fractionDigits: 2))
            XCTAssertEqual(viewModel.typedSecondMeasurement, Double(26).regionFormatted(fractionDigits: 2))
            XCTAssertEqual(viewModel.typedThirdMeasurement, Double(27.5).regionFormatted(fractionDigits: 2))
        case "Call didChange text":
            switch currentExpectation?.currentFulfillmentCount {
            case 0:
                XCTAssertEqual(viewModel.typedFirstMeasurement, Double(21.48).regionFormatted(fractionDigits: 2))
                XCTAssertNil(viewModel.typedSecondMeasurement)
                XCTAssertNil(viewModel.typedThirdMeasurement)
            case 1:
                XCTAssertEqual(viewModel.typedFirstMeasurement, Double(21.48).regionFormatted(fractionDigits: 2))
                XCTAssertEqual(viewModel.typedSecondMeasurement, Double(22.19).regionFormatted(fractionDigits: 2))
                XCTAssertNil(viewModel.typedThirdMeasurement)
            case 2:
                XCTAssertEqual(viewModel.typedFirstMeasurement, Double(21.48).regionFormatted(fractionDigits: 2))
                XCTAssertEqual(viewModel.typedSecondMeasurement, Double(22.19).regionFormatted(fractionDigits: 2))
                XCTAssertEqual(viewModel.typedThirdMeasurement, Double(19.81).regionFormatted(fractionDigits: 2))
            default:
                XCTFail("Unexpected fullfillment count: \(currentExpectation?.currentFulfillmentCount ?? -1)")
            }
        case "Call update invalid":
            XCTAssertNil(viewModel.typedFirstMeasurement)
            XCTAssertNil(viewModel.typedSecondMeasurement)
            XCTAssertNil(viewModel.typedThirdMeasurement)
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
