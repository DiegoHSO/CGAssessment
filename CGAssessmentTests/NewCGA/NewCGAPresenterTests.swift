//
//  NewCGAPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 30/10/23.
//

import XCTest
@testable import CGAssessment

final class NewCGAPresenterTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?

    override func tearDown() {
        super.tearDown()
        currentExpectation = nil
    }

    // MARK: - Test Methods

    func testRouteToCGADomains() {
        let newExpectation = expectation(description: "Call routeTo CGADomains")
        currentExpectation = newExpectation

        let presenter = NewCGAPresenter(viewController: self)

        guard let patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        presenter.route(toRoute: .cgaDomains(patientId: patientId))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = NewCGAPresenter(viewController: self)

        guard let patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        presenter.presentData(viewModel: .init(patients: [.init(patient: .init(patientName: "Test Patient", patientAge: 53, gender: .male),
                                                                id: patientId, delegate: nil)], selectedInternalOption: .firstOption, selectedExternalOption: .firstOption, patientName: "Test", selectedPatient: nil,
                                               isDone: true, isSearching: false))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentAlert() {
        let newExpectation = expectation(description: "Call presentAlert")
        currentExpectation = newExpectation

        let presenter = NewCGAPresenter(viewController: self)
        presenter.presentAlert()

        wait(for: [newExpectation], timeout: 1)
    }

}

// MARK: - NewCGAPresentationLogic extension

extension NewCGAPresenterTests: NewCGADisplayLogic {
    func presentAlert() {
        XCTAssertEqual(currentExpectation?.description, "Call presentAlert")
        currentExpectation?.fulfill()
    }

    func route(toRoute route: NewCGAModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo CGADomains":
            guard let patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3") else {
                XCTFail("Unexpected UUID")
                return
            }
            XCTAssertEqual(route, .cgaDomains(patientId: patientId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: NewCGAModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            guard let patientId = UUID(uuidString: "2334772b-cd5b-4392-9148-7bf1994dd8d3") else {
                XCTFail("Unexpected UUID")
                return
            }

            XCTAssertEqual(viewModel.patientName, "Test")
            XCTAssertEqual(viewModel.patients.first?.patient.patientName, "Test Patient")
            XCTAssertEqual(viewModel.patients.first?.patient.patientAge, 53)
            XCTAssertEqual(viewModel.patients.first?.patient.gender, .male)
            XCTAssertEqual(viewModel.patients.first?.id, patientId)
            XCTAssertEqual(viewModel.selectedExternalOption, .firstOption)
            XCTAssertEqual(viewModel.selectedInternalOption, .firstOption)
            XCTAssertNil(viewModel.patients.first?.delegate)
            XCTAssertNil(viewModel.selectedPatient)
            XCTAssertTrue(viewModel.isDone)
            XCTAssertFalse(viewModel.isSearching)

            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
