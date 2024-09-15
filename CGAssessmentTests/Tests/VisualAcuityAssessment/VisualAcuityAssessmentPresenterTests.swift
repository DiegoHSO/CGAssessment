//
//  VisualAcuityAssessmentPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 03/11/23.
//

import XCTest
@testable import CGAssessment

final class VisualAcuityAssessmentPresenterTests: XCTestCase {

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

        let presenter = VisualAcuityAssessmentPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .visualAcuityAssessment, results: .init(selectedOption: .twelfthOption), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteToPrinting() {
        let newExpectation = expectation(description: "Call routeTo printing")
        currentExpectation = newExpectation

        let presenter = VisualAcuityAssessmentPresenter(viewController: self)
        presenter.route(toRoute: .printing(fileURL: Bundle.main.url(forResource: "snellen_chart", withExtension: "pdf")))

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteToPDFSaving() {
        let newExpectation = expectation(description: "Call routeTo PDF saving")
        currentExpectation = newExpectation

        let presenter = VisualAcuityAssessmentPresenter(viewController: self)
        presenter.route(toRoute: .pdfSaving(pdfData: Bundle.main.url(forResource: "snellen_chart", withExtension: "pdf")))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = VisualAcuityAssessmentPresenter(viewController: self)
        presenter.presentData(viewModel: .init(instructions: [], buttons: [], question: .init(question: .visualAcuityAssessmentQuestion,
                                                                                              selectedOption: .fourteenthOption, options: [:]),
                                               selectedOption: .eighthOption, isResultsButtonEnabled: false))
        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - VisualAcuityAssessmentPresentationLogic extension

extension VisualAcuityAssessmentPresenterTests: VisualAcuityAssessmentDisplayLogic {
    func route(toRoute route: VisualAcuityAssessmentModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .visualAcuityAssessment, results: .init(selectedOption: .twelfthOption), cgaId: nil))
        case "Call routeTo printing":
            XCTAssertEqual(route, .printing(fileURL: Bundle.main.url(forResource: "snellen_chart", withExtension: "pdf")))
        case "Call routeTo PDF saving":
            XCTAssertEqual(route, .pdfSaving(pdfData: Bundle.main.url(forResource: "snellen_chart", withExtension: "pdf")))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: VisualAcuityAssessmentModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.question, .init(question: .visualAcuityAssessmentQuestion, selectedOption: .fourteenthOption, options: [:]))
            XCTAssertEqual(viewModel.selectedOption, .eighthOption)
            XCTAssertTrue(viewModel.instructions.isEmpty)
            XCTAssertTrue(viewModel.buttons.isEmpty)
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
