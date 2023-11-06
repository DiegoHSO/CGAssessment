//
//  MiniMentalStateExamInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class MiniMentalStateExamInteractorTests: XCTestCase {

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

        let worker = MiniMentalStateExamWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniMentalStateExamInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = MiniMentalStateExamWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniMentalStateExamInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectCopiedTheDrawingOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect copiedTheDrawing option")

        currentExpectation = newExpectation

        let worker = MiniMentalStateExamWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniMentalStateExamInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .firstOption, value: .copiedTheDrawing)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectDidntCopyTheDrawingOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect didn't copyTheDrawing option")

        currentExpectation = newExpectation

        let worker = MiniMentalStateExamWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniMentalStateExamInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .didntCopyTheDrawing)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect option")

        currentExpectation = newExpectation

        let worker = MiniMentalStateExamWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniMentalStateExamInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .miniMentalStateExamFirstQuestion)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectBinaryOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect binaryOption")

        currentExpectation = newExpectation

        let worker = MiniMentalStateExamWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniMentalStateExamInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .yes, numberIdentifier: 1, sectionIdentifier: .miniMentalStateExamFirstSectionQuestion)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = TestExpectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = MiniMentalStateExamWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = MiniMentalStateExamInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didSelect(option: .firstOption, value: .miniMentalStateExamFirstQuestion)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - MiniMentalStateExamPresentationLogic extension

extension MiniMentalStateExamInteractorTests: MiniMentalStateExamPresentationLogic {
    func route(toRoute route: MiniMentalStateExamModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .miniMentalStateExamination, results: .init(questions: [.miniMentalStateExamFirstQuestion: .secondOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                                                                                             .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                                                                                             .miniMentalStateExamFifthQuestion: .firstOption],
                                                                                                 binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .yes, 2: .not, 3: .not, 4: .yes, 5: .yes],
                                                                                                                   .miniMentalStateExamSecondSectionQuestion: [1: .not, 2: .yes, 3: .yes, 4: .yes, 5: .not],
                                                                                                                   .miniMentalStateExamThirdSectionQuestion: [1: .not, 2: .yes, 3: .yes],
                                                                                                                   .miniMentalStateExamFourthSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .not, 5: .not],
                                                                                                                   .miniMentalStateExamFifthSectionQuestion: [1: .yes, 2: .not, 3: .yes],
                                                                                                                   .miniMentalStateExamSixthSectionQuestion: [1: .yes, 2: .yes],
                                                                                                                   .miniMentalStateExamSeventhSectionQuestion: [1: .yes, 2: .yes, 3: .not]]), cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: MiniMentalStateExamModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertTrue(viewModel.questions.allSatisfy { $0.value.selectedOption != .none })
            XCTAssertTrue(viewModel.binaryQuestions.allSatisfy({ $0.value.options.allSatisfy { $0.value != .none } }))
        case "Call didSelect copiedTheDrawing option":
            guard let value = viewModel.questions.first(where: { $0.value.question == nil })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .firstOption)
        case "Call didSelect didn't copyTheDrawing option":
            guard let value = viewModel.questions.first(where: { $0.value.question == nil })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .secondOption)
        case "Call didSelect binaryOption":
            guard let value = viewModel.binaryQuestions.first(where: { $0.value.title == .miniMentalStateExamFirstSectionQuestion })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertEqual(value.options[1], .yes)
        case "Call didSelect option":
            guard let value = viewModel.questions.first(where: { $0.value.question == .miniMentalStateExamFirstQuestion })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .secondOption)
        case "Call update invalid":
            XCTAssertTrue(viewModel.questions.filter({ $0.value.question != .miniMentalStateExamFirstQuestion })
                            .allSatisfy { $0.value.selectedOption == .none })
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
