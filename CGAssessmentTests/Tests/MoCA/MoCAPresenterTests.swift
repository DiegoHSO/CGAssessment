//
//  MoCAPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import XCTest
@testable import CGAssessment

final class MoCAPresenterTests: XCTestCase {

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

        let presenter = MoCAPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .moca, results: .init(binaryQuestions: [:], selectedEducationOption: .secondOption, countedWords: 38), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteToGallery() {
        let newExpectation = expectation(description: "Call routeTo Gallery")
        currentExpectation = newExpectation

        let presenter = MoCAPresenter(viewController: self)
        presenter.route(toRoute: .imagePicker(configuration: .init(), delegate: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testRouteToCamera() {
        let newExpectation = expectation(description: "Call routeTo Camera")
        currentExpectation = newExpectation

        let presenter = MoCAPresenter(viewController: self)
        presenter.route(toRoute: .camera)

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = MoCAPresenter(viewController: self)
        presenter.presentData(viewModel: .init(question: .init(question: .mocaFirstSectionFirstQuestion, selectedOption: .thirdOption,
                                                               options: [:]), countedWords: 134, selectedOption: .firstOption,
                                               binaryQuestions: [:], circlesImage: nil, watchImage: nil, groupedButtons: [],
                                               circlesProgress: nil, watchProgress: nil, isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }

    func testDismissPresentingController() {
        let newExpectation = expectation(description: "Call dismiss presentingController")
        currentExpectation = newExpectation

        let presenter = MoCAPresenter(viewController: self)
        presenter.dismissPresentingController()

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - MoCAPresentationLogic extension

extension MoCAPresenterTests: MoCADisplayLogic {
    func route(toRoute route: MoCAModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .moca, results: .init(binaryQuestions: [:], selectedEducationOption: .secondOption, countedWords: 38), cgaId: nil))
        case "Call routeTo Gallery":
            XCTAssertEqual(route, .imagePicker(configuration: .init(), delegate: nil))
        case "Call routeTo Camera":
            XCTAssertEqual(route, .camera)
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: MoCAModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.question, .init(question: .mocaFirstSectionFirstQuestion, selectedOption: .thirdOption, options: [:]))
            XCTAssertTrue(viewModel.selectedOption == .firstOption)
            XCTAssertTrue(viewModel.binaryQuestions.isEmpty)
            XCTAssertTrue(viewModel.countedWords == 134)
            XCTAssertTrue(viewModel.groupedButtons.isEmpty)
            XCTAssertNil(viewModel.circlesImage)
            XCTAssertNil(viewModel.watchImage)
            XCTAssertNil(viewModel.circlesProgress)
            XCTAssertNil(viewModel.watchProgress)
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }

    func dismissPresentingController() {
        XCTAssertEqual(currentExpectation?.description, "Call dismiss presentingController")
        currentExpectation?.fulfill()
    }
}
