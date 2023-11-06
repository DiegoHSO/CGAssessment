//
//  ApgarScalePresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 03/11/23.
//

import XCTest
@testable import CGAssessment

final class ApgarScalePresenterTests: XCTestCase {

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

        let presenter = ApgarScalePresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .apgarScale, results: .init(questions: [.apgarScaleQuestionOne: .secondOption]), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = ApgarScalePresenter(viewController: self)
        presenter.presentData(viewModel: .init(questions: [.init(question: .apgarScaleQuestionFive, selectedOption: .firstOption, options: [:])], isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - ApgarScalePresentationLogic extension

extension ApgarScalePresenterTests: ApgarScaleDisplayLogic {
    func route(toRoute route: ApgarScaleModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .apgarScale, results: .init(questions: [.apgarScaleQuestionOne: .secondOption]), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: ApgarScaleModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.questions, [.init(question: .apgarScaleQuestionFive,
                                                       selectedOption: .firstOption, options: [:])])
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
