//
//  MiniNutritionalAssessmentInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 03/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class MiniNutritionalAssessmentInteractorTests: XCTestCase {

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

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniNutritionalAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniNutritionalAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniNutritionalAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .secondOption, value: .miniNutritionalAssessmentFirstQuestion)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectTooltip() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect tooltip")

        currentExpectation = newExpectation

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniNutritionalAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelectTooltip()

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectTooltipAndNavigating() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect tooltip and navigating")

        currentExpectation = newExpectation

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniNutritionalAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelectTooltip()
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidTapWeightPicker() {
        let newExpectation = TestExpectation(description: "Call didTap weight picker")
        currentExpectation = newExpectation

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniNutritionalAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didTapPicker(identifier: .weight)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapHeightPicker() {
        let newExpectation = TestExpectation(description: "Call didTap height picker")
        currentExpectation = newExpectation

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniNutritionalAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didTapPicker(identifier: .height)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapInvalidPicker() {
        let newExpectation = TestExpectation(description: "Call didTap invalid picker")
        currentExpectation = newExpectation

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniNutritionalAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didTapPicker(identifier: nil)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectWeightPickerRow() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniNutritionalAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)

        let firstExpectation = TestExpectation(description: "Call controllerDidLoad")
        firstExpectation.expectedFulfillmentCount = 2

        currentExpectation = firstExpectation

        interactor.controllerDidLoad()

        let secondExpectation = TestExpectation(description: "Call didSelect weight picker row")
        currentExpectation = secondExpectation

        interactor.didSelectPickerRow(identifier: .weight, row: 5)

        wait(for: [saveExpectation, firstExpectation, secondExpectation], timeout: 1)
    }

    func testDidSelectHeightPickerRow() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniNutritionalAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)

        let firstExpectation = TestExpectation(description: "Call controllerDidLoad")
        firstExpectation.expectedFulfillmentCount = 2

        currentExpectation = firstExpectation

        interactor.controllerDidLoad()

        let secondExpectation = TestExpectation(description: "Call didSelect height picker row")
        currentExpectation = secondExpectation

        interactor.didSelectPickerRow(identifier: .height, row: 5)

        wait(for: [saveExpectation, firstExpectation, secondExpectation], timeout: 1)
    }

    func testDidSelectInvalidPickerRow() {
        let newExpectation = TestExpectation(description: "Call didSelect invalid picker row")
        currentExpectation = newExpectation

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MiniNutritionalAssessmentInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelectPickerRow(identifier: nil, row: 5)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = TestExpectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = MiniNutritionalAssessmentWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = MiniNutritionalAssessmentInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didSelect(option: .firstOption, value: .miniNutritionalAssessmentSecondQuestion)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - MiniNutritionalAssessmentPresentationLogic extension

extension MiniNutritionalAssessmentInteractorTests: MiniNutritionalAssessmentPresentationLogic {
    func route(toRoute route: MiniNutritionalAssessmentModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .miniNutritionalAssessment, results: .init(questions: [
                .miniNutritionalAssessmentFirstQuestion: .thirdOption, .miniNutritionalAssessmentSecondQuestion: .fourthOption,
                .miniNutritionalAssessmentThirdQuestion: .thirdOption, .miniNutritionalAssessmentFourthQuestion: .firstOption,
                .miniNutritionalAssessmentFifthQuestion: .thirdOption, .miniNutritionalAssessmentSeventhQuestion: .none
            ], height: 174, weight: 80.5, isExtraQuestionSelected: false), cgaId: cgaId))
        case "Call didSelect tooltip and navigating":
            XCTAssertEqual(route, .testResults(test: .miniNutritionalAssessment, results: .init(questions: [
                .miniNutritionalAssessmentFirstQuestion: .thirdOption, .miniNutritionalAssessmentSecondQuestion: .fourthOption,
                .miniNutritionalAssessmentThirdQuestion: .thirdOption, .miniNutritionalAssessmentFourthQuestion: .firstOption,
                .miniNutritionalAssessmentFifthQuestion: .thirdOption, .miniNutritionalAssessmentSeventhQuestion: .none
            ], height: 174, weight: 80.5, isExtraQuestionSelected: true), cgaId: cgaId))
        case "Call didTap weight picker":
            XCTAssertEqual(route, .openBottomSheet(viewModel: .init(pickerContent: Array(stride(from: 0.0, to: 500, by: 0.5)).map { "\($0.regionFormatted()) kg" }, identifier: .weight, delegate: nil, selectedRow: 0)))
        case "Call didTap height picker":
            XCTAssertEqual(route, .openBottomSheet(viewModel: .init(pickerContent: Array(0...299).map({ "\($0) cm" }), identifier: .height, delegate: nil, selectedRow: 0)))
        case "Call didTap invalid picker":
            XCTAssertEqual(route, .openBottomSheet(viewModel: .init(pickerContent: [], identifier: nil, delegate: nil, selectedRow: 0)))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: MiniNutritionalAssessmentModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertTrue(viewModel.questions.flatMap({ $0.value }).filter({ $0.question != .miniNutritionalAssessmentSeventhQuestion }).allSatisfy { $0.selectedOption != .none })
        case "Call didSelect option":
            guard let value = viewModel.questions.flatMap({ $0.value }).first(where: { $0.question == .miniNutritionalAssessmentFirstQuestion }) else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .secondOption)
        case "Call didSelect tooltip", "Call didSelect tooltip and navigating":
            XCTAssertTrue(viewModel.isExtraQuestionSelected)
        case "Call didSelect weight picker row":
            XCTAssertEqual(viewModel.weight, "2,5")
        case "Call didSelect height picker row":
            XCTAssertEqual(viewModel.height, "5")
        case "Call update invalid":
            XCTAssertTrue(viewModel.questions.flatMap({ $0.value }).filter({ $0.question != .miniNutritionalAssessmentSecondQuestion })
                            .allSatisfy { $0.selectedOption == .none })
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
