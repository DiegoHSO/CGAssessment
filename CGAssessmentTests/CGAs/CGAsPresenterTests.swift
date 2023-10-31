//
//  CGAsPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 30/10/23.
//

import XCTest
@testable import CGAssessment

final class CGAsPresenterTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?

    // MARK: - Life Cycle

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        currentExpectation = nil
    }

    // MARK: - Test Methods

    func testRouteToNewCGA() {
        let newExpectation = expectation(description: "Call routeTo NewCGA")
        currentExpectation = newExpectation

        let presenter = CGAsPresenter(viewController: self)
        presenter.route(toRoute: .newCGA)

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteToCGA() {
        let newExpectation = expectation(description: "Call routeTo CGA")
        currentExpectation = newExpectation

        let presenter = CGAsPresenter(viewController: self)
        presenter.route(toRoute: .cgaDomains(cgaId: UUID(uuidString: "1334772b-cd5b-4392-9148-7bf1994dd8d3")))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = CGAsPresenter(viewController: self)
        presenter.presentData(viewModel: .init(filterOptions: [.byPatient, .recent, .zToA], selectedFilter: .byPatient, patientName: "Test Patient"))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentDeletionAlert() {
        let newExpectation = expectation(description: "Call presentDeletionAlert")
        currentExpectation = newExpectation

        let presenter = CGAsPresenter(viewController: self)
        presenter.presentDeletionAlert(for: IndexPath(row: 0, section: 0))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentErrorDeletingAlert() {
        let newExpectation = expectation(description: "Call presentErrorDeletingAlert")
        currentExpectation = newExpectation

        let presenter = CGAsPresenter(viewController: self)
        presenter.presentErrorDeletingAlert()

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - CGAsPresentationLogic extension

extension CGAsPresenterTests: CGAsDisplayLogic {
    func presentDeletionAlert(for indexPath: IndexPath) {
        XCTAssertEqual(currentExpectation?.description, "Call presentDeletionAlert")
        XCTAssertEqual(indexPath, IndexPath(row: 0, section: 0))
        currentExpectation?.fulfill()
    }

    func presentErrorDeletingAlert() {
        XCTAssertEqual(currentExpectation?.description, "Call presentErrorDeletingAlert")
        currentExpectation?.fulfill()
    }

    func route(toRoute route: CGAsModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo NewCGA":
            XCTAssertEqual(route, .newCGA)
        case "Call routeTo CGA":
            XCTAssertEqual(route, .cgaDomains(cgaId: UUID(uuidString: "1334772b-cd5b-4392-9148-7bf1994dd8d3")))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: CGAsModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.selectedFilter, .byPatient)
            XCTAssertEqual(viewModel.patientName, "Test Patient")
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
