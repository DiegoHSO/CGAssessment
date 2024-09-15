//
//  SingleDomainPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 31/10/23.
//

import XCTest
@testable import CGAssessment

final class SingleDomainPresenterTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?

    override func tearDown() {
        super.tearDown()
        currentExpectation = nil
    }

    // MARK: - Test Methods

    func testRouteToDomain() {
        let newExpectation = expectation(description: "Call routeTo Test")
        currentExpectation = newExpectation

        let presenter = SingleDomainPresenter(viewController: self)
        presenter.route(toRoute: .domainTest(test: .calfCircumference, cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = SingleDomainPresenter(viewController: self)
        presenter.presentData(viewModel: .init(domain: .comorbidity,
                                               tests: [.init(test: .charlsonIndex, status: .incomplete)],
                                               statusViewModel: .init(patientName: "Test Patient", patientBirthDate: nil, cgaCreationDate: Date(), cgaLastModifiedDate: Date()), sections: 2))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - SingleDomainPresentationLogic extension

extension SingleDomainPresenterTests: SingleDomainDisplayLogic {
    func route(toRoute route: SingleDomainModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Test":
            XCTAssertEqual(route, .domainTest(test: .calfCircumference, cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: SingleDomainModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.domain, .comorbidity)
            XCTAssertEqual(viewModel.tests.first?.test, .charlsonIndex)
            XCTAssertEqual(viewModel.tests.first?.status, .incomplete)
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Test Patient")
            XCTAssertEqual(viewModel.sections, 2)
            XCTAssertNil(viewModel.statusViewModel?.patientBirthDate)
            XCTAssertNotNil(viewModel.statusViewModel?.cgaCreationDate)
            XCTAssertNotNil(viewModel.statusViewModel?.cgaLastModifiedDate)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
