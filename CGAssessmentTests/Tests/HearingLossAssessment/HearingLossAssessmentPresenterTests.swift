//
//  HearingLossAssessmentPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 03/11/23.
//

import XCTest
@testable import CGAssessment

final class HearingLossAssessmentPresenterTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?

    override func tearDown() {
        super.tearDown()
        currentExpectation = nil
    }

    // MARK: - Test Methods

    func testRouteToKatzScale() {
        let newExpectation = expectation(description: "Call routeTo KatzScale")
        currentExpectation = newExpectation

        let presenter = HearingLossAssessmentPresenter(viewController: self)
        presenter.route(toRoute: .katzScale(cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = HearingLossAssessmentPresenter(viewController: self)
        presenter.presentData(viewModel: .init(instructions: [], isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - HearingLossAssessmentPresentationLogic extension

extension HearingLossAssessmentPresenterTests: HearingLossAssessmentDisplayLogic {
    func route(toRoute route: HearingLossAssessmentModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo KatzScale":
            XCTAssertEqual(route, .katzScale(cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: HearingLossAssessmentModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
