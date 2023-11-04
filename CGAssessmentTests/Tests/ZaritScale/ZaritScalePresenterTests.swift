//
//  ZaritScalePresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import XCTest
@testable import CGAssessment

final class ZaritScalePresenterTests: XCTestCase {

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

        let presenter = ZaritScalePresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .zaritScale, results: .init(questions: [.zaritScaleQuestionOne: .secondOption]), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = ZaritScalePresenter(viewController: self)
        presenter.presentData(viewModel: .init(questions: [.init(question: .zaritScaleQuestionFive, selectedOption: .firstOption, options: [:])], isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - ZaritScalePresentationLogic extension

extension ZaritScalePresenterTests: ZaritScaleDisplayLogic {
    func route(toRoute route: ZaritScaleModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .zaritScale, results: .init(questions: [.zaritScaleQuestionOne: .secondOption]), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: ZaritScaleModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.questions, [.init(question: .zaritScaleQuestionFive,
                                                       selectedOption: .firstOption, options: [:])])
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
