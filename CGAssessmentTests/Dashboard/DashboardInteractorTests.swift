//
//  DashboardInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 29/10/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class DashboardInteractorTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?
    private var dao: CoreDataDAOProtocol?

    // MARK: - Life Cycle

    override func setUp() {
        super.setUp()
        dao = CoreDataDAOMock()
        try? dao?.addStandaloneCGA()
    }

    override func tearDown() {
        super.tearDown()
        currentExpectation = nil
        dao = nil
    }

    // MARK: - Test Methods

    func testControllerDidLoad() {
        let newExpectation = expectation(description: "Call controllerDidLoad")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerWillDisappear() {
        let newExpectation = expectation(description: "Call controllerWillDisappear")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.controllerWillDisappear()

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToReviewCGAs() {
        let newExpectation = expectation(description: "Call didTapToReviewCGAs")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.didTapToReviewCGAs()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapToSeeCGAExample() {
        let newExpectation = expectation(description: "Call didTapToSeeCGAExample")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.didTapToSeeCGAExample()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectPatients() {
        let newExpectation = expectation(description: "Call didSelect Patients")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.didSelect(menuOption: .patients)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectCGAs() {
        let newExpectation = expectation(description: "Call didSelect CGAs")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.didSelect(menuOption: .cgas)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectNewCGA() {
        let newExpectation = expectation(description: "Call didSelect NewCGA")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.didSelect(menuOption: .newCGA)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectReports() {
        let newExpectation = expectation(description: "Call didSelect Reports")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.didSelect(menuOption: .reports)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectCGADomains() {
        let newExpectation = expectation(description: "Call didSelect CGADomains")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.didSelect(menuOption: .cgaDomains)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectCGAExample() {
        let newExpectation = expectation(description: "Call didSelect CGAExample")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.didSelect(menuOption: .cgaExample)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectEvaluation() {
        let newExpectation = expectation(description: "Call didSelect Evaluation")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.didSelect(menuOption: .evaluation(id: UUID(uuidString: "1334772b-cd5b-4392-9148-7bf1994dd8d3")))

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectLastCGA() {
        let newExpectation = expectation(description: "Call didSelect LastCGA")
        newExpectation.expectedFulfillmentCount = 2

        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.controllerDidLoad()
        interactor.didSelect(menuOption: .lastCGA)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapPatientsComponent() {
        let newExpectation = expectation(description: "Call didTap Patients")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.didTapComponent(identifier: .patients)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapNewCGAComponent() {
        let newExpectation = expectation(description: "Call didTap NewCGA")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.didTapComponent(identifier: .newCGA)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapReportsComponent() {
        let newExpectation = expectation(description: "Call didTap Reports")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.didTapComponent(identifier: .reports)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapCGADomainsComponent() {
        let newExpectation = expectation(description: "Call didTap CGADomains")
        currentExpectation = newExpectation

        let worker = DashboardWorker(dao: dao ?? DAOFactory.coreDataDAO)

        let interactor = DashboardInteractor(presenter: self, worker: worker)
        interactor.didTapComponent(identifier: .cgaDomains)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - DashboardPresentationLogic extension

extension DashboardInteractorTests: DashboardPresentationLogic {
    func route(toRoute route: DashboardModels.Routing) {
        switch currentExpectation?.description {
        case "Call didTapToReviewCGAs", "Call didSelect CGAs":
            XCTAssertEqual(route, .cgas)
        case "Call didTapToSeeCGAExample", "Call didSelect CGADomains", "Call didTap CGADomains":
            XCTAssertEqual(route, .cgaDomains)
        case "Call didSelect Patients", "Call didTap Patients":
            XCTAssertEqual(route, .patients)
        case "Call didSelect NewCGA", "Call didTap NewCGA":
            XCTAssertEqual(route, .newCGA)
        case "Call didSelect Reports", "Call didTap Reports":
            XCTAssertEqual(route, .reports)
        case "Call didSelect CGAExample":
            XCTAssertEqual(route, .cga(cgaId: nil))
        case "Call didSelect Evaluation":
            XCTAssertEqual(route, .cga(cgaId: UUID(uuidString: "1334772b-cd5b-4392-9148-7bf1994dd8d3")))
        case "Call didSelect LastCGA":
            XCTAssertEqual(route, .cga(cgaId: UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3")))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: DashboardModels.ViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didSelect LastCGA":
            XCTAssertEqual(viewModel.latestEvaluation?.id, UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3"))
            XCTAssertEqual(viewModel.todoEvaluations.first?.id, UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3"))
            currentExpectation?.fulfill()
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }
    }
}
