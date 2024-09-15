//
//  SuspectedAbusePresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import XCTest
@testable import CGAssessment

final class SuspectedAbusePresenterTests: XCTestCase {

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

        let presenter = SuspectedAbusePresenter(viewController: self)
        presenter.route(toRoute: .chemotherapyToxicityRisk(cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = SuspectedAbusePresenter(viewController: self)
        presenter.presentData(viewModel: .init(selectedOption: .secondOption, textViewModel:
                                                .init(title: nil, text: "Test abuse text", placeholder: nil, delegate: nil), isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - SuspectedAbusePresentationLogic extension

extension SuspectedAbusePresenterTests: SuspectedAbuseDisplayLogic {
    func route(toRoute route: SuspectedAbuseModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .chemotherapyToxicityRisk(cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: SuspectedAbuseModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.selectedOption, .secondOption)
            XCTAssertEqual(viewModel.textViewModel.text, "Test abuse text")
            XCTAssertNil(viewModel.textViewModel.title)
            XCTAssertNil(viewModel.textViewModel.placeholder)
            XCTAssertNil(viewModel.textViewModel.delegate)
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
