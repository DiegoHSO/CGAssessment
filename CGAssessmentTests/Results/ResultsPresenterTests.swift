//
//  ResultsPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 31/10/23.
//

import XCTest
@testable import CGAssessment

final class ResultsPresenterTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?

    override func tearDown() {
        super.tearDown()
        currentExpectation = nil
    }

    // MARK: - Test Methods

    func testRouteToNextTest() {
        let newExpectation = expectation(description: "Call routeTo nextTest")
        currentExpectation = newExpectation

        let presenter = ResultsPresenter(viewController: self)
        presenter.route(toRoute: .nextTest(test: .apgarScale))

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteToSarcopeniaAssessment() {
        let newExpectation = expectation(description: "Call routeTo sarcopeniaAssessment")
        currentExpectation = newExpectation

        let presenter = ResultsPresenter(viewController: self)
        presenter.route(toRoute: .sarcopeniaAssessment)

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteBack() {
        let newExpectation = expectation(description: "Call routeBack")
        currentExpectation = newExpectation

        let presenter = ResultsPresenter(viewController: self)
        presenter.route(toRoute: .routeBack(domain: .nutritional))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = ResultsPresenter(viewController: self)
        presenter.presentData(viewModel: .init(testName: "Mock test", results: [.init(title: "Test result", description: "Test description")], resultType: .good, isInSpecialFlow: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - ResultsPresentationLogic extension

extension ResultsPresenterTests: ResultsDisplayLogic {
    func route(toRoute route: ResultsModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo nextTest":
            XCTAssertEqual(route, .nextTest(test: .apgarScale))
        case "Call routeTo sarcopeniaAssessment":
            XCTAssertEqual(route, .sarcopeniaAssessment)
        case "Call routeBack":
            XCTAssertEqual(route, .routeBack(domain: .nutritional))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: ResultsModels.ViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.testName, "Mock test")
            XCTAssertEqual(viewModel.results.first?.title, "Test result")
            XCTAssertEqual(viewModel.results.first?.description, "Test description")
            XCTAssertEqual(viewModel.resultType, .good)
            XCTAssertFalse(viewModel.isInSpecialFlow)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
