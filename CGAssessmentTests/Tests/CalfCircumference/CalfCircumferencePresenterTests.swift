//
//  CalfCircumferencePresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import XCTest
@testable import CGAssessment

final class CalfCircumferencePresenterTests: XCTestCase {

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

        let presenter = CalfCircumferencePresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .calfCircumference, results: .init(circumference: 21.4), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = CalfCircumferencePresenter(viewController: self)
        presenter.presentData(viewModel: .init(instructions: [], typedCircumference: "23.1",
                                               imageName: nil, isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - CalfCircumferencePresentationLogic extension

extension CalfCircumferencePresenterTests: CalfCircumferenceDisplayLogic {
    func route(toRoute route: CalfCircumferenceModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .calfCircumference, results: .init(circumference: 21.4), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: CalfCircumferenceModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.typedCircumference, "23.1")
            XCTAssertNil(viewModel.imageName)
            XCTAssertTrue(viewModel.instructions.isEmpty)
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
