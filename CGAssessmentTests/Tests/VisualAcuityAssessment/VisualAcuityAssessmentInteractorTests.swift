//
//  VisualAcuityAssessmentInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 03/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class VisualAcuityAssessmentInteractorTests: XCTestCase {

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

        let worker = VisualAcuityAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = VisualAcuityAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = VisualAcuityAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = VisualAcuityAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect option")

        currentExpectation = newExpectation

        let worker = VisualAcuityAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = VisualAcuityAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .tenthOption, value: .none)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectPrint() {
        let newExpectation = TestExpectation(description: "Call didSelect print")

        currentExpectation = newExpectation

        let worker = VisualAcuityAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = VisualAcuityAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(buttonIdentifier: .print)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectSavePDF() {
        let newExpectation = TestExpectation(description: "Call didSelect savePDF")

        currentExpectation = newExpectation

        let worker = VisualAcuityAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = VisualAcuityAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(buttonIdentifier: .savePDF)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectInvalidIdentifier() {
        let newExpectation = TestExpectation(description: "Call didSelect invalid")

        currentExpectation = newExpectation

        let worker = VisualAcuityAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = VisualAcuityAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(buttonIdentifier: .none)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = TestExpectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = VisualAcuityAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = VisualAcuityAssessmentInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didSelect(option: .tenthOption, value: .none)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - VisualAcuityAssessmentPresentationLogic extension

extension VisualAcuityAssessmentInteractorTests: VisualAcuityAssessmentPresentationLogic {
    func route(toRoute route: VisualAcuityAssessmentModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .visualAcuityAssessment, results: .init(selectedOption: .ninthOption), cgaId: cgaId))
        case "Call didSelect print":
            XCTAssertEqual(route, .printing(fileURL: Bundle.main.url(forResource: "snellen_chart", withExtension: "pdf")))
        case "Call didSelect savePDF":
            XCTAssertEqual(route, .pdfSaving(pdfData: Bundle.main.url(forResource: "snellen_chart", withExtension: "pdf")))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: VisualAcuityAssessmentModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertTrue(viewModel.selectedOption == .ninthOption)
        case "Call didSelect option", "Call update invalid":
            XCTAssertTrue(viewModel.selectedOption == .tenthOption)
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
