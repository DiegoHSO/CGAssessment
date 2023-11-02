//
//  TimedUpAndGoPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import XCTest
@testable import CGAssessment

final class TimedUpAndGoPresenterTests: XCTestCase {

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

    func testRouteToResults() {
        let newExpectation = expectation(description: "Call routeTo Results")
        currentExpectation = newExpectation

        let presenter = TimedUpAndGoPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .timedUpAndGo, results: .init(elapsedTime: 15.45), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = TimedUpAndGoPresenter(viewController: self)
        presenter.presentData(viewModel: .init(instructions: [], selectedOption: .secondOption,
                                               typedElapsedTime: "45.32", stopwatchElapsedTime: 30.56,
                                               isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - TimedUpAndGoPresentationLogic extension

extension TimedUpAndGoPresenterTests: TimedUpAndGoDisplayLogic {
    func route(toRoute route: TimedUpAndGoModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .timedUpAndGo, results: .init(elapsedTime: 15.45), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: TimedUpAndGoModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.stopwatchElapsedTime, 30.56)
            XCTAssertEqual(viewModel.typedElapsedTime, "45.32")
            XCTAssertEqual(viewModel.selectedOption, .secondOption)
            XCTAssertTrue(viewModel.instructions.isEmpty)
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
