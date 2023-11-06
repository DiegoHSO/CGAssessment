//
//  CharlsonIndexInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class CharlsonIndexInteractorTests: XCTestCase {

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

        let worker = CharlsonIndexWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = CharlsonIndexInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = CharlsonIndexWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = CharlsonIndexInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectBinaryOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect binaryOption")

        currentExpectation = newExpectation

        let worker = CharlsonIndexWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = CharlsonIndexInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .not, numberIdentifier: 4, sectionIdentifier: .charlsonIndexMainQuestion)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = TestExpectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = CharlsonIndexWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = CharlsonIndexInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didSelect(option: .not, numberIdentifier: 2, sectionIdentifier: .outline)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - CharlsonIndexPresentationLogic extension

extension CharlsonIndexInteractorTests: CharlsonIndexPresentationLogic {
    func route(toRoute route: CharlsonIndexModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .charlsonIndex, results: .init(binaryQuestions: [
                .charlsonIndexMainQuestion: [1: .yes, 2: .not, 3: .yes, 4: .not, 5: .not, 6: .not,
                                             7: .not, 8: .not, 9: .not, 10: .not, 11: .not, 12: .not,
                                             13: .not, 14: .not, 15: .not, 16: .not, 17: .not, 18: .not]
            ], patientBirthDate: Date().addingYear(-75).removingTimeComponents()), cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: CharlsonIndexModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertTrue(viewModel.binaryQuestions.allSatisfy({ $0.value.options.allSatisfy { $0.value != .none } }))
        case "Call didSelect binaryOption":
            guard let value = viewModel.binaryQuestions.first(where: { $0.value.sectionIdentifier == .charlsonIndexMainQuestion })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertEqual(value.options[4], .not)
        case "Call update invalid":
            XCTAssertTrue(viewModel.binaryQuestions.map({ $0.value.options })
                            .allSatisfy { $0.filter { $0.key != 2 }.allSatisfy({ $0.value == .none }) })
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
