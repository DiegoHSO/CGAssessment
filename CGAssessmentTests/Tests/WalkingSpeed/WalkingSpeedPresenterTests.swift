//
//  WalkingSpeedPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import XCTest
@testable import CGAssessment

final class WalkingSpeedPresenterTests: XCTestCase {

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

        let presenter = WalkingSpeedPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .walkingSpeed, results: .init(firstElapsedTime: 32.1, secondElapsedTime: 28.9, thirdElapsedTime: 26.5), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = WalkingSpeedPresenter(viewController: self)
        presenter.presentData(viewModel: .init(instructions: [], selectedOption: .secondOption,
                                               typedFirstTime: "45.32", typedSecondTime: "40.22", typedThirdTime: "37.75",
                                               firstStopwatchTime: 21.23, secondStopwatchTime: 42.32,
                                               thirdStopwatchTime: 34.53, selectedStopwatch: .second, isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - WalkingSpeedPresentationLogic extension

extension WalkingSpeedPresenterTests: WalkingSpeedDisplayLogic {
    func route(toRoute route: WalkingSpeedModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .walkingSpeed, results: .init(firstElapsedTime: 32.1, secondElapsedTime: 28.9, thirdElapsedTime: 26.5), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: WalkingSpeedModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.typedFirstTime, "45.32")
            XCTAssertEqual(viewModel.typedSecondTime, "40.22")
            XCTAssertEqual(viewModel.typedThirdTime, "37.75")
            XCTAssertEqual(viewModel.firstStopwatchTime, 21.23)
            XCTAssertEqual(viewModel.secondStopwatchTime, 42.32)
            XCTAssertEqual(viewModel.thirdStopwatchTime, 34.53)
            XCTAssertEqual(viewModel.selectedOption, .secondOption)
            XCTAssertEqual(viewModel.selectedStopwatch, .second)
            XCTAssertTrue(viewModel.instructions.isEmpty)
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
