//
//  VerbalFluencyPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import XCTest
@testable import CGAssessment

final class VerbalFluencyPresenterTests: XCTestCase {

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

        let presenter = VerbalFluencyPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .verbalFluencyTest, results: .init(countedWords: 34, selectedEducationOption: .secondOption), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = VerbalFluencyPresenter(viewController: self)
        presenter.presentData(viewModel: .init(instructions: [], question: .init(question: nil, selectedOption: .none, options: [:]),
                                               countedWords: 45, selectedOption: .firstOption, elapsedTime: 120, isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - VerbalFluencyPresentationLogic extension

extension VerbalFluencyPresenterTests: VerbalFluencyDisplayLogic {
    func route(toRoute route: VerbalFluencyModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .verbalFluencyTest, results: .init(countedWords: 34, selectedEducationOption: .secondOption), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: VerbalFluencyModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.question, .init(question: nil, selectedOption: .none, options: [:]))
            XCTAssertEqual(viewModel.countedWords, 45)
            XCTAssertEqual(viewModel.elapsedTime, 120)
            XCTAssertEqual(viewModel.selectedOption, .firstOption)
            XCTAssertTrue(viewModel.instructions.isEmpty)
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
