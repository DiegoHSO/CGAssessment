//
//  LawtonScalePresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 03/11/23.
//

import XCTest
@testable import CGAssessment

final class LawtonScalePresenterTests: XCTestCase {

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

        let presenter = LawtonScalePresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .katzScale, results: .init(questions: [.telephone: .secondOption]), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = LawtonScalePresenter(viewController: self)
        presenter.presentData(viewModel: .init(questions: [.secondQuestion: .init(question: nil, selectedOption: .thirdOption, options: [:])], isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - LawtonScalePresentationLogic extension

extension LawtonScalePresenterTests: LawtonScaleDisplayLogic {
    func route(toRoute route: LawtonScaleModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .katzScale, results: .init(questions: [.telephone: .secondOption]), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: LawtonScaleModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.questions, [.secondQuestion: .init(question: nil,
                                                                        selectedOption: .thirdOption, options: [:])])
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
