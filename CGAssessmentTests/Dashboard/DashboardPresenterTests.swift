//
//  DashboardPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 29/10/23.
//

import XCTest
@testable import CGAssessment

final class DashboardPresenterTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?

    override func tearDown() {
        super.tearDown()
        currentExpectation = nil
    }

    // MARK: - Test Methods

    func testRouteToPatients() {
        let newExpectation = expectation(description: "Call routeTo Patients")
        currentExpectation = newExpectation

        let presenter = DashboardPresenter(viewController: self)
        presenter.route(toRoute: .patients)

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteToCGAs() {
        let newExpectation = expectation(description: "Call routeTo CGAs")
        currentExpectation = newExpectation

        let presenter = DashboardPresenter(viewController: self)
        presenter.route(toRoute: .cgas)

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteToNewCGA() {
        let newExpectation = expectation(description: "Call routeTo NewCGA")
        currentExpectation = newExpectation

        let presenter = DashboardPresenter(viewController: self)
        presenter.route(toRoute: .newCGA)

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteToReports() {
        let newExpectation = expectation(description: "Call routeTo Reports")
        currentExpectation = newExpectation

        let presenter = DashboardPresenter(viewController: self)
        presenter.route(toRoute: .reports)

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteToCGADomains() {
        let newExpectation = expectation(description: "Call routeTo CGADomains")
        currentExpectation = newExpectation

        let presenter = DashboardPresenter(viewController: self)
        presenter.route(toRoute: .cgaDomains)

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteToCGA() {
        let newExpectation = expectation(description: "Call routeTo CGA")
        currentExpectation = newExpectation

        let presenter = DashboardPresenter(viewController: self)
        presenter.route(toRoute: .cga(cgaId: UUID(uuidString: "1334772b-cd5b-4392-9148-7bf1994dd8d3")))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = DashboardPresenter(viewController: self)
        presenter.presentData(viewModel: .init(latestEvaluation: .init(patientName: "Test CGA", patientAge: 55, missingDomains: 5, id: UUID()),
                                               todoEvaluations: [.init(patientName: "CGA Test", patientAge: 43, alteredDomains: 2, nextApplicationDate: Date(),
                                                                       lastApplicationDate: Date(), id: UUID())]))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - DashboardPresentationLogic extension

extension DashboardPresenterTests: DashboardDisplayLogic {
    func route(toRoute route: DashboardModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo CGAs":
            XCTAssertEqual(route, .cgas)
        case "Call routeTo CGADomains":
            XCTAssertEqual(route, .cgaDomains)
        case "Call routeTo Patients":
            XCTAssertEqual(route, .patients)
        case "Call routeTo NewCGA":
            XCTAssertEqual(route, .newCGA)
        case "Call routeTo Reports":
            XCTAssertEqual(route, .reports)
        case "Call routeTo CGA":
            XCTAssertEqual(route, .cga(cgaId: UUID(uuidString: "1334772b-cd5b-4392-9148-7bf1994dd8d3")))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: DashboardModels.ViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.latestEvaluation?.patientName, "Test CGA")
            XCTAssertEqual(viewModel.todoEvaluations.first?.patientName, "CGA Test")
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
