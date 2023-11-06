//
//  PatientsPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 31/10/23.
//

import XCTest
@testable import CGAssessment

final class PatientsPresenterTests: XCTestCase {

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

        let presenter = PatientsPresenter(viewController: self)
        presenter.route(toRoute: .newCGA)

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteToCGA() {
        let newExpectation = expectation(description: "Call routeTo CGAs")
        currentExpectation = newExpectation

        let presenter = PatientsPresenter(viewController: self)
        presenter.route(toRoute: .cgas(patientId: UUID(uuidString: "1334772b-cd5b-4392-9148-7bf1994dd8d3")))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = PatientsPresenter(viewController: self)
        presenter.presentData(viewModel: .init(patients: [], filterOptions: [.byPatient, .recent, .zToA],
                                               selectedFilter: .byPatient, isSearching: true))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentDeletionAlert() {
        let newExpectation = expectation(description: "Call presentDeletionAlert")
        currentExpectation = newExpectation

        let presenter = PatientsPresenter(viewController: self)
        presenter.presentDeletionAlert(for: IndexPath(row: 0, section: 0))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentErrorDeletingAlert() {
        let newExpectation = expectation(description: "Call presentErrorDeletingAlert")
        currentExpectation = newExpectation

        let presenter = PatientsPresenter(viewController: self)
        presenter.presentErrorDeletingAlert()

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - PatientsPresentationLogic extension

extension PatientsPresenterTests: PatientsDisplayLogic {
    func presentDeletionAlert(for indexPath: IndexPath) {
        XCTAssertEqual(currentExpectation?.description, "Call presentDeletionAlert")
        XCTAssertEqual(indexPath, IndexPath(row: 0, section: 0))
        currentExpectation?.fulfill()
    }

    func presentErrorDeletingAlert() {
        XCTAssertEqual(currentExpectation?.description, "Call presentErrorDeletingAlert")
        currentExpectation?.fulfill()
    }

    func route(toRoute route: PatientsModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo NewCGA":
            XCTAssertEqual(route, .newCGA)
        case "Call routeTo CGAs":
            XCTAssertEqual(route, .cgas(patientId: UUID(uuidString: "1334772b-cd5b-4392-9148-7bf1994dd8d3")))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: PatientsModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.selectedFilter, .byPatient)
            XCTAssertEqual(viewModel.filterOptions, [.byPatient, .recent, .zToA])
            XCTAssertTrue(viewModel.isSearching)
            XCTAssertTrue(viewModel.patients.isEmpty)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
