//
//  ChemotherapyToxicityRiskPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import XCTest
@testable import CGAssessment

final class ChemotherapyToxicityRiskPresenterTests: XCTestCase {

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

        let presenter = ChemotherapyToxicityRiskPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .chemotherapyToxicityRisk, results: .init(questions: [.chemotherapyToxicityRiskQuestionOne: .secondOption]), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = ChemotherapyToxicityRiskPresenter(viewController: self)
        presenter.presentData(viewModel: .init(questions: [.init(question: .chemotherapyToxicityRiskQuestionFive, selectedOption: .firstOption, options: [:])], isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - ChemotherapyToxicityRiskPresentationLogic extension

extension ChemotherapyToxicityRiskPresenterTests: ChemotherapyToxicityRiskDisplayLogic {
    func route(toRoute route: ChemotherapyToxicityRiskModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .chemotherapyToxicityRisk, results: .init(questions: [.chemotherapyToxicityRiskQuestionOne: .secondOption]), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: ChemotherapyToxicityRiskModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.questions, [.init(question: .chemotherapyToxicityRiskQuestionFive,
                                                       selectedOption: .firstOption, options: [:])])
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
