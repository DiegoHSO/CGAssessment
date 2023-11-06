//
//  MiniMentalStateExamPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import XCTest
@testable import CGAssessment

final class MiniMentalStateExamPresenterTests: XCTestCase {

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

        let presenter = MiniMentalStateExamPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .sarcopeniaScreening, results: .init(questions: [.miniMentalStateExamFirstQuestion: .thirdOption],
                                                                                         binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .yes]]), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = MiniMentalStateExamPresenter(viewController: self)
        presenter.presentData(viewModel: .init(questions: [.secondQuestion: .init(question: .miniMentalStateExamFirstQuestion, selectedOption: .thirdOption, options: [:])], binaryQuestions: [:], isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - MiniMentalStateExamPresentationLogic extension

extension MiniMentalStateExamPresenterTests: MiniMentalStateExamDisplayLogic {
    func route(toRoute route: MiniMentalStateExamModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .sarcopeniaScreening, results: .init(questions: [.miniMentalStateExamFirstQuestion: .thirdOption],
                                                                                          binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .yes]]), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: MiniMentalStateExamModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.questions, [.secondQuestion: .init(question: .miniMentalStateExamFirstQuestion,
                                                                        selectedOption: .thirdOption, options: [:])])
            XCTAssertTrue(viewModel.binaryQuestions.isEmpty)
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
