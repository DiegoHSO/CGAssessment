//
//  MiniNutritionalAssessmentPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 03/11/23.
//

import XCTest
@testable import CGAssessment

final class MiniNutritionalAssessmentPresenterTests: XCTestCase {

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

        let presenter = MiniNutritionalAssessmentPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .miniNutritionalAssessment, results: .init(questions: [.miniNutritionalAssessmentFirstQuestion: .secondOption],
                                                                                               height: 163, weight: 97, isExtraQuestionSelected: false), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = MiniNutritionalAssessmentPresenter(viewController: self)
        presenter.presentData(viewModel: .init(questions: [.questions: [.init(question: .miniNutritionalAssessmentFirstQuestion,
                                                                              selectedOption: .thirdOption, options: [:])]],
                                               pickers: [], height: "165 cm", weight: "81 kg", pickerContent: [:],
                                               isExtraQuestionSelected: false, isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - MiniNutritionalAssessmentPresentationLogic extension

extension MiniNutritionalAssessmentPresenterTests: MiniNutritionalAssessmentDisplayLogic {
    func route(toRoute route: MiniNutritionalAssessmentModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .miniNutritionalAssessment, results: .init(questions: [.miniNutritionalAssessmentFirstQuestion: .secondOption],
                                                                                                height: 163, weight: 97, isExtraQuestionSelected: false), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: MiniNutritionalAssessmentModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.questions, [.questions: [.init(question: .miniNutritionalAssessmentFirstQuestion,
                                                                    selectedOption: .thirdOption, options: [:])]])
            XCTAssertEqual(viewModel.height, "165 cm")
            XCTAssertEqual(viewModel.weight, "81 kg")
            XCTAssertTrue(viewModel.pickers.isEmpty)
            XCTAssertTrue(viewModel.pickerContent.isEmpty)
            XCTAssertFalse(viewModel.isExtraQuestionSelected)
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
