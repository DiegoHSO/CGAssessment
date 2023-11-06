//
//  LawtonScaleInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 03/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class LawtonScaleInteractorTests: XCTestCase {

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

        let worker = LawtonScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = LawtonScaleInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = LawtonScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = LawtonScaleInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectTelephoneOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect telephone option")

        currentExpectation = newExpectation

        let worker = LawtonScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = LawtonScaleInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .lawtonScaleQuestionOneOptionOne)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectTripsOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect trips option")

        currentExpectation = newExpectation

        let worker = LawtonScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = LawtonScaleInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .lawtonScaleQuestionTwoOptionOne)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectShoppingOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect shopping option")

        currentExpectation = newExpectation

        let worker = LawtonScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = LawtonScaleInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .lawtonScaleQuestionThreeOptionOne)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectMealPreparationOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect meal preparation option")

        currentExpectation = newExpectation

        let worker = LawtonScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = LawtonScaleInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .lawtonScaleQuestionFourOptionOne)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectHouseworkOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect housework option")

        currentExpectation = newExpectation

        let worker = LawtonScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = LawtonScaleInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .lawtonScaleQuestionFiveOptionOne)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectMedicineOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect medicine option")

        currentExpectation = newExpectation

        let worker = LawtonScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = LawtonScaleInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .lawtonScaleQuestionSixOptionOne)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectMoneyOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect money option")

        currentExpectation = newExpectation

        let worker = LawtonScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = LawtonScaleInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .lawtonScaleQuestionSevenOptionOne)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectInvalidOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect invalid option")

        currentExpectation = newExpectation

        let worker = LawtonScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = LawtonScaleInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .none)

        currentExpectation?.fulfill()

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = TestExpectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = LawtonScaleWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = LawtonScaleInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didSelect(option: .firstOption, value: .lawtonScaleQuestionOneOptionOne)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - LawtonScalePresentationLogic extension

extension LawtonScaleInteractorTests: LawtonScalePresentationLogic {
    func route(toRoute route: LawtonScaleModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .lawtonScale, results: .init(questions: [
                .telephone: .thirdOption, .trips: .firstOption, .shopping: .firstOption, .mealPreparation: .firstOption,
                .housework: .secondOption, .medicine: .firstOption, .money: .firstOption
            ]), cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: LawtonScaleModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertTrue(viewModel.questions.allSatisfy { $0.value.selectedOption != .none })
        case "Call didSelect telephone option":
            guard let value = viewModel.questions.first(where: { $0.value.options.contains(where: { $0.value == .lawtonScaleQuestionOneOptionOne }) })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .secondOption)
        case "Call didSelect trips option":
            guard let value = viewModel.questions.first(where: { $0.value.options.contains(where: { $0.value == .lawtonScaleQuestionTwoOptionOne }) })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .secondOption)
        case "Call didSelect shopping option":
            guard let value = viewModel.questions.first(where: { $0.value.options.contains(where: { $0.value == .lawtonScaleQuestionThreeOptionOne }) })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .secondOption)
        case "Call didSelect meal preparation option":
            guard let value = viewModel.questions.first(where: { $0.value.options.contains(where: { $0.value == .lawtonScaleQuestionFourOptionOne }) })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .secondOption)
        case "Call didSelect housework option":
            guard let value = viewModel.questions.first(where: { $0.value.options.contains(where: { $0.value == .lawtonScaleQuestionFiveOptionOne }) })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .secondOption)
        case "Call didSelect medicine option":
            guard let value = viewModel.questions.first(where: { $0.value.options.contains(where: { $0.value == .lawtonScaleQuestionSixOptionOne }) })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .secondOption)
        case "Call didSelect money option":
            guard let value = viewModel.questions.first(where: { $0.value.options.contains(where: { $0.value == .lawtonScaleQuestionSevenOptionOne }) })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .secondOption)
        case "Call didSelect invalid option":
            XCTAssertTrue(viewModel.questions.map({ $0.value })
                            .allSatisfy { $0.selectedOption == .none })
        case "Call update invalid":
            XCTAssertTrue(viewModel.questions.filter({ !$0.value.options.contains(where: { $0.value == .lawtonScaleQuestionOneOptionOne }) })
                            .allSatisfy { $0.value.selectedOption == .none })
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
