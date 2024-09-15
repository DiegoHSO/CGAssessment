//
//  SarcopeniaAssessmentPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import XCTest
@testable import CGAssessment

final class SarcopeniaAssessmentPresenterTests: XCTestCase {

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

        let presenter = SarcopeniaAssessmentPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .sarcopeniaAssessment, results: .init(gripStrengthResults: .init(firstMeasurement: 12, secondMeasurement: 13,
                                                                                                                     thirdMeasurement: 14, gender: .male),
                                                                                          calfCircumferenceResults: nil,
                                                                                          timedUpAndGoResults: nil, walkingSpeedResults: nil), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteToTest() {
        let newExpectation = expectation(description: "Call routeTo Test")
        currentExpectation = newExpectation

        let presenter = SarcopeniaAssessmentPresenter(viewController: self)
        presenter.route(toRoute: .calfCircumference(cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = SarcopeniaAssessmentPresenter(viewController: self)
        presenter.presentData(viewModel: .init(testsCompletionStatus: [:], testsResults: [.timedUpAndGo: .good, .walkingSpeed: .bad]))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - SarcopeniaAssessmentPresentationLogic extension

extension SarcopeniaAssessmentPresenterTests: SarcopeniaAssessmentDisplayLogic {
    func route(toRoute route: SarcopeniaAssessmentModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .sarcopeniaAssessment, results: .init(gripStrengthResults: .init(firstMeasurement: 12, secondMeasurement: 13,
                                                                                                                      thirdMeasurement: 14, gender: .male),
                                                                                           calfCircumferenceResults: nil, timedUpAndGoResults: nil,
                                                                                           walkingSpeedResults: nil), cgaId: nil))
        case "Call routeTo Test":
            XCTAssertEqual(route, .calfCircumference(cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: SarcopeniaAssessmentModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.testsCompletionStatus, [:])
            XCTAssertEqual(viewModel.testsResults[.timedUpAndGo], .good)
            XCTAssertEqual(viewModel.testsResults[.walkingSpeed], .bad)
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
