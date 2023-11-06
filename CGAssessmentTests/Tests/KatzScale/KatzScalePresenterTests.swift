//
//  KatzScalePresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 03/11/23.
//

import XCTest
@testable import CGAssessment

final class KatzScalePresenterTests: XCTestCase {

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

        let presenter = KatzScalePresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .katzScale, results: .init(questions: [.katzScaleQuestionOne: .secondOption]), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = KatzScalePresenter(viewController: self)
        presenter.presentData(viewModel: .init(questions: [.init(question: .katzScaleQuestionOne, selectedOption: .firstOption, options: [:])], isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - KatzScalePresentationLogic extension

extension KatzScalePresenterTests: KatzScaleDisplayLogic {
    func route(toRoute route: KatzScaleModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .katzScale, results: .init(questions: [.katzScaleQuestionOne: .secondOption]), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: KatzScaleModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.questions, [.init(question: .katzScaleQuestionOne,
                                                       selectedOption: .firstOption, options: [:])])
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
