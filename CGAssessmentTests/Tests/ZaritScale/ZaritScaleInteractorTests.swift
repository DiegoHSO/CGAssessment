//
//  ZaritScaleInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class ZaritScaleInteractorTests: XCTestCase {

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

        let worker = ZaritScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = ZaritScaleInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = ZaritScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = ZaritScaleInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = ZaritScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = ZaritScaleInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .zaritScaleQuestionOne)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = TestExpectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = ZaritScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = ZaritScaleInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didSelect(option: .secondOption, value: .zaritScaleQuestionFour)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - ZaritScalePresentationLogic extension

extension ZaritScaleInteractorTests: ZaritScalePresentationLogic {
    func route(toRoute route: ZaritScaleModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .zaritScale, results: .init(questions: [.zaritScaleQuestionOne: .firstOption, .zaritScaleQuestionTwo: .firstOption, .zaritScaleQuestionThree: .firstOption,
                                                                                             .zaritScaleQuestionFour: .firstOption, .zaritScaleQuestionFive: .secondOption, .zaritScaleQuestionSix: .secondOption,
                                                                                             .zaritScaleQuestionSeven: .secondOption
            ]), cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: ZaritScaleModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertTrue(viewModel.questions.allSatisfy { $0.selectedOption != .none })
        case "Call didSelect option":
            guard let value = viewModel.questions.first(where: { $0.question == .zaritScaleQuestionOne }) else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .secondOption)
        case "Call update invalid":
            XCTAssertTrue(viewModel.questions.filter({ $0.question != .zaritScaleQuestionFour })
                            .allSatisfy { $0.selectedOption == .none })
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
