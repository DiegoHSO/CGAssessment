//
//  SarcopeniaScreeningPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import XCTest
@testable import CGAssessment

final class SarcopeniaScreeningPresenterTests: XCTestCase {

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

        let presenter = SarcopeniaScreeningPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .sarcopeniaScreening, results: .init(questions: [.sarcopeniaAssessmentFirstQuestion: .thirdOption]), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = SarcopeniaScreeningPresenter(viewController: self)
        presenter.presentData(viewModel: .init(questions: [.secondQuestion: .init(question: .sarcopeniaAssessmentSecondQuestion, selectedOption: .thirdOption, options: [:])], isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - SarcopeniaScreeningPresentationLogic extension

extension SarcopeniaScreeningPresenterTests: SarcopeniaScreeningDisplayLogic {
    func route(toRoute route: SarcopeniaScreeningModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .sarcopeniaScreening, results: .init(questions: [.sarcopeniaAssessmentFirstQuestion: .thirdOption]), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: SarcopeniaScreeningModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.questions, [.secondQuestion: .init(question: .sarcopeniaAssessmentSecondQuestion,
                                                                        selectedOption: .thirdOption, options: [:])])
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
