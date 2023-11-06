//
//  SarcopeniaScreeningInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class SarcopeniaScreeningInteractorTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: TestExpectation?
    private var dao: CoreDataDAOMock?
    private let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3")

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
        let newExpectation = TestExpectation(description: "Call controllerDidLoad")
        newExpectation.expectedFulfillmentCount = 2

        currentExpectation = newExpectation

        let worker = SarcopeniaScreeningWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SarcopeniaScreeningInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapActionButton() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didTap action button")
        newExpectation.expectedFulfillmentCount = 3

        currentExpectation = newExpectation

        let worker = SarcopeniaScreeningWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SarcopeniaScreeningInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect option")

        currentExpectation = newExpectation

        let worker = SarcopeniaScreeningWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = SarcopeniaScreeningInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .sarcopeniaAssessmentFirstQuestion)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = TestExpectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = SarcopeniaScreeningWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = SarcopeniaScreeningInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didSelect(option: .thirdOption, value: .sarcopeniaAssessmentFourthQuestion)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - SarcopeniaScreeningPresentationLogic extension

extension SarcopeniaScreeningInteractorTests: SarcopeniaScreeningPresentationLogic {
    func route(toRoute route: SarcopeniaScreeningModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .sarcopeniaScreening, results: .init(questions: [.sarcopeniaAssessmentFirstQuestion: .thirdOption, .sarcopeniaAssessmentSecondQuestion: .secondOption,
                                                                                                      .sarcopeniaAssessmentThirdQuestion: .secondOption, .sarcopeniaAssessmentFourthQuestion: .firstOption,
                                                                                                      .sarcopeniaAssessmentFifthQuestion: .secondOption, .sarcopeniaAssessmentSixthQuestion: .secondOption]), cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: SarcopeniaScreeningModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertTrue(viewModel.questions.allSatisfy { $0.value.selectedOption != .none })
        case "Call didSelect option":
            guard let value = viewModel.questions.first(where: { $0.value.question == .sarcopeniaAssessmentFirstQuestion })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .secondOption)
        case "Call update invalid":
            XCTAssertTrue(viewModel.questions.filter({ $0.value.question != .sarcopeniaAssessmentFourthQuestion })
                            .allSatisfy { $0.value.selectedOption == .none })
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
