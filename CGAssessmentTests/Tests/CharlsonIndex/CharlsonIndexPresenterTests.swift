//
//  CharlsonIndexPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import XCTest
@testable import CGAssessment

final class CharlsonIndexPresenterTests: XCTestCase {

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

        let presenter = CharlsonIndexPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .charlsonIndex, results: .init(binaryQuestions: [.charlsonIndexMainQuestion: [1: .yes]], patientBirthDate: nil), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = CharlsonIndexPresenter(viewController: self)
        presenter.presentData(viewModel: .init(binaryQuestions: [:], isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - CharlsonIndexPresentationLogic extension

extension CharlsonIndexPresenterTests: CharlsonIndexDisplayLogic {
    func route(toRoute route: CharlsonIndexModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .charlsonIndex, results: .init(binaryQuestions: [.charlsonIndexMainQuestion: [1: .yes]], patientBirthDate: nil), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: CharlsonIndexModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertTrue(viewModel.binaryQuestions.isEmpty)
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
