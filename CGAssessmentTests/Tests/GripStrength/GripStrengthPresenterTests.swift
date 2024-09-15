//
//  GripStrengthPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import XCTest
@testable import CGAssessment

final class GripStrengthPresenterTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?

    override func tearDown() {
        super.tearDown()
        currentExpectation = nil
    }

    // MARK: - Test Methods

    func testRouteToResults() {
        let newExpectation = expectation(description: "Call routeTo Results")
        currentExpectation = newExpectation

        let presenter = GripStrengthPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .gripStrength, results: .init(firstMeasurement: 32.1, secondMeasurement: 28.9,
                                                                                  thirdMeasurement: 26.5, gender: .male), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = GripStrengthPresenter(viewController: self)
        presenter.presentData(viewModel: .init(instructions: [], typedFirstMeasurement: "45.32", typedSecondMeasurement: "40.22",
                                               typedThirdMeasurement: "37.75", imageName: nil, isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - GripStrengthPresentationLogic extension

extension GripStrengthPresenterTests: GripStrengthDisplayLogic {
    func route(toRoute route: GripStrengthModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .gripStrength, results: .init(firstMeasurement: 32.1, secondMeasurement: 28.9,
                                                                                   thirdMeasurement: 26.5, gender: .male), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: GripStrengthModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.typedFirstMeasurement, "45.32")
            XCTAssertEqual(viewModel.typedSecondMeasurement, "40.22")
            XCTAssertEqual(viewModel.typedThirdMeasurement, "37.75")
            XCTAssertNil(viewModel.imageName)
            XCTAssertTrue(viewModel.instructions.isEmpty)
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
