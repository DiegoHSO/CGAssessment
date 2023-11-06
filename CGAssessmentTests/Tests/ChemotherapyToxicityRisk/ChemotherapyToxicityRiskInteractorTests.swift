//
//  ChemotherapyToxicityRiskInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class ChemotherapyToxicityRiskInteractorTests: XCTestCase {

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

    func testControllerDidLoadWithDefaultPatient() {
        let newExpectation = TestExpectation(description: "Call controllerDidLoad with default patient")
        newExpectation.expectedFulfillmentCount = 2

        currentExpectation = newExpectation

        let worker = ChemotherapyToxicityRiskWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = ChemotherapyToxicityRiskInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()

        wait(for: [newExpectation], timeout: 1)
    }

    func testControllerDidLoadWithNewPatient() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }
        saveExpectation.expectedFulfillmentCount = 2

        let newExpectation = TestExpectation(description: "Call controllerDidLoad with new patient")

        currentExpectation = newExpectation

        let newCGAWorker = NewCGAWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let patientId = try? newCGAWorker.savePatient(patientData: .init(patientName: "Test patient", birthDate: Date().addingYear(-65).removingTimeComponents(), gender: .male))

        let cgaDomainsWorker = CGADomainsWorker(dao: dao ?? DAOFactory.coreDataDAO)
        let newCgaId = try? cgaDomainsWorker.saveCGA(for: patientId ?? UUID())

        let worker = ChemotherapyToxicityRiskWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: newCgaId)

        let interactor = ChemotherapyToxicityRiskInteractor(presenter: self, worker: worker, cgaId: newCgaId)
        interactor.controllerDidLoad()

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidTapActionButton() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let worker = ChemotherapyToxicityRiskWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = ChemotherapyToxicityRiskInteractor(presenter: self, worker: worker, cgaId: cgaId)

        let firstExpectation = TestExpectation(description: "Call controllerDidLoad with default patient")
        firstExpectation.expectedFulfillmentCount = 2

        currentExpectation = firstExpectation

        interactor.controllerDidLoad()

        let secondExpectation = TestExpectation(description: "Call didTap action button")

        currentExpectation = secondExpectation

        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, firstExpectation, secondExpectation], timeout: 1)
    }

    func testDidSelectOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect option")

        currentExpectation = newExpectation

        let worker = ChemotherapyToxicityRiskWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = ChemotherapyToxicityRiskInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .firstOption, value: .chemotherapyToxicityRiskQuestionOne)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = TestExpectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = ChemotherapyToxicityRiskWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = ChemotherapyToxicityRiskInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didSelect(option: .secondOption, value: .chemotherapyToxicityRiskQuestionFour)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - ChemotherapyToxicityRiskPresentationLogic extension

extension ChemotherapyToxicityRiskInteractorTests: ChemotherapyToxicityRiskPresentationLogic {
    func route(toRoute route: ChemotherapyToxicityRiskModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad with default patient":
            XCTAssertEqual(route, .testResults(test: .chemotherapyToxicityRisk, results: .init(questions: [
                .chemotherapyToxicityRiskQuestionOne: .secondOption, .chemotherapyToxicityRiskQuestionTwo: .firstOption,
                .chemotherapyToxicityRiskQuestionThree: .secondOption, .chemotherapyToxicityRiskQuestionFour: .secondOption,
                .chemotherapyToxicityRiskQuestionFive: .secondOption, .chemotherapyToxicityRiskQuestionSix: .secondOption,
                .chemotherapyToxicityRiskQuestionSeven: .secondOption, .chemotherapyToxicityRiskQuestionEight: .firstOption,
                .chemotherapyToxicityRiskQuestionNine: .secondOption, .chemotherapyToxicityRiskQuestionTen: .secondOption,
                .chemotherapyToxicityRiskQuestionEleven: .secondOption
            ]), cgaId: cgaId))
        case "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .chemotherapyToxicityRisk, results: .init(questions: [
                .chemotherapyToxicityRiskQuestionOne: .secondOption, .chemotherapyToxicityRiskQuestionTwo: .firstOption,
                .chemotherapyToxicityRiskQuestionThree: .secondOption, .chemotherapyToxicityRiskQuestionFour: .secondOption,
                .chemotherapyToxicityRiskQuestionFive: .secondOption, .chemotherapyToxicityRiskQuestionSix: .secondOption,
                .chemotherapyToxicityRiskQuestionSeven: .secondOption, .chemotherapyToxicityRiskQuestionEight: .firstOption,
                .chemotherapyToxicityRiskQuestionNine: .secondOption, .chemotherapyToxicityRiskQuestionTen: .secondOption,
                .chemotherapyToxicityRiskQuestionEleven: .firstOption
            ]), cgaId: cgaId))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: ChemotherapyToxicityRiskModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad with default patient":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertEqual(viewModel.questions.first(where: { $0.question == .chemotherapyToxicityRiskQuestionEleven })?.selectedOption, .firstOption)
            XCTAssertTrue(viewModel.questions.allSatisfy { $0.selectedOption != .none })
        case "Call controllerDidLoad with new patient":
            XCTAssertFalse(viewModel.isResultsButtonEnabled)
            XCTAssertEqual(viewModel.questions.first(where: { $0.question == .chemotherapyToxicityRiskQuestionEleven })?.selectedOption, .secondOption)
            XCTAssertTrue(viewModel.questions.filter({ $0.question != .chemotherapyToxicityRiskQuestionEleven }).allSatisfy { $0.selectedOption == .none })
        case "Call didSelect option":
            guard let value = viewModel.questions.first(where: { $0.question == .chemotherapyToxicityRiskQuestionOne }) else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertTrue(value.selectedOption == .firstOption)
        case "Call update invalid":
            XCTAssertTrue(viewModel.questions.filter({ $0.question != .chemotherapyToxicityRiskQuestionFour })
                            .allSatisfy { $0.selectedOption == .none })
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
