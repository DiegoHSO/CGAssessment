//
//  PolypharmacyCriteriaPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import XCTest
@testable import CGAssessment

final class PolypharmacyCriteriaPresenterTests: XCTestCase {

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

        let presenter = PolypharmacyCriteriaPresenter(viewController: self)
        presenter.route(toRoute: .testResults(test: .polypharmacyCriteria, results: .init(numberOfMedicines: 15), cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = PolypharmacyCriteriaPresenter(viewController: self)
        presenter.presentData(viewModel: .init(instructions: [], picker: .init(title: nil, pickerName: .numberOfMedicines,
                                                                               pickerValue: "4 medicamentos", delegate: nil),
                                               pickerContent: ["1 medicamento"], isResultsButtonEnabled: false))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - PolypharmacyCriteriaPresentationLogic extension

extension PolypharmacyCriteriaPresenterTests: PolypharmacyCriteriaDisplayLogic {
    func route(toRoute route: PolypharmacyCriteriaModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Results":
            XCTAssertEqual(route, .testResults(test: .polypharmacyCriteria, results: .init(numberOfMedicines: 15), cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: PolypharmacyCriteriaModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.picker.pickerName, .numberOfMedicines)
            XCTAssertEqual(viewModel.picker.pickerValue, "4 medicamentos")
            XCTAssertNil(viewModel.picker.title)
            XCTAssertNil(viewModel.picker.delegate)
            XCTAssertTrue(viewModel.instructions.isEmpty)
            XCTAssertTrue(viewModel.pickerContent.first == "1 medicamento")
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
