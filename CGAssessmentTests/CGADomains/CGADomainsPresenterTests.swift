//
//  CGADomainsPresenterTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 31/10/23.
//

import XCTest
@testable import CGAssessment

final class CGADomainsPresenterTests: XCTestCase {

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

    func testRouteToDomain() {
        let newExpectation = expectation(description: "Call routeTo Domain")
        currentExpectation = newExpectation

        let presenter = CGADomainsPresenter(viewController: self)
        presenter.route(toRoute: .domainTests(domain: .polypharmacy, cgaId: nil))

        wait(for: [newExpectation], timeout: 1)
    }

    func testPresentData() {
        let newExpectation = expectation(description: "Call presentData")
        currentExpectation = newExpectation

        let presenter = CGADomainsPresenter(viewController: self)
        presenter.presentData(viewModel: .init(domains: [.nutritional: [.miniNutritionalAssessment: true],
                                                         .cognitive: [.moca: false]], statusViewModel: .init(patientName: "Test Patient", patientBirthDate: nil, cgaCreationDate: Date(), cgaLastModifiedDate: Date())))

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - CGADomainsPresentationLogic extension

extension CGADomainsPresenterTests: CGADomainsDisplayLogic {
    func route(toRoute route: CGADomainsModels.Routing) {
        switch currentExpectation?.description {
        case "Call routeTo Domain":
            XCTAssertEqual(route, .domainTests(domain: .polypharmacy, cgaId: nil))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: CGADomainsModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call presentData":
            XCTAssertEqual(viewModel.domains[.nutritional]?.first?.value, true)
            XCTAssertEqual(viewModel.domains[.cognitive]?.first?.value, false)
            XCTAssertEqual(viewModel.statusViewModel?.patientName, "Test Patient")
            XCTAssertNil(viewModel.statusViewModel?.patientBirthDate)
            XCTAssertNotNil(viewModel.statusViewModel?.cgaCreationDate)
            XCTAssertNotNil(viewModel.statusViewModel?.cgaLastModifiedDate)
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
