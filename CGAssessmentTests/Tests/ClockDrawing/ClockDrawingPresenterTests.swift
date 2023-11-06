//
//  ClockDrawingPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 02/11/23.
//

import XCTest
@testable import CGAssessment

final class ClockDrawingPresenterTests: XCTestCase {

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

        let presenter = ClockDrawingPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .clockDrawingTest, results: .init(binaryQuestions: [.pointers: [1: .yes]]), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = ClockDrawingPresenter(viewController: self)
        presenter.presentData(viewModel: .init(instructions: [], binaryQuestions: [:], isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - ClockDrawingPresentationLogic extension

extension ClockDrawingPresenterTests: ClockDrawingDisplayLogic {
    func route(toRoute route: ClockDrawingModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .clockDrawingTest, results: .init(binaryQuestions: [.pointers: [1: .yes]]), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: ClockDrawingModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertTrue(viewModel.instructions.isEmpty)
            XCTAssertTrue(viewModel.binaryQuestions.isEmpty)
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
