//
//  PolypharmacyCriteriaInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 04/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class PolypharmacyCriteriaInteractorTests: XCTestCase {

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

        let worker = PolypharmacyCriteriaWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = PolypharmacyCriteriaInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = PolypharmacyCriteriaWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = PolypharmacyCriteriaInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.controllerDidLoad()
        interactor.didTapActionButton(identifier: nil)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidTapPicker() {
        let newExpectation = TestExpectation(description: "Call didTap picker")
        currentExpectation = newExpectation

        let worker = PolypharmacyCriteriaWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = PolypharmacyCriteriaInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didTapPicker(identifier: .numberOfMedicines)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidTapPickerSingleMedicine() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didTap picker single medicine")
        newExpectation.expectedFulfillmentCount = 2

        currentExpectation = newExpectation

        let worker = PolypharmacyCriteriaWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = PolypharmacyCriteriaInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelectPickerRow(identifier: .numberOfMedicines, row: 1)
        interactor.didTapPicker(identifier: .numberOfMedicines)

        wait(for: [newExpectation, saveExpectation], timeout: 1)
    }

    func testDidSelectSingleMedicinePickerRow() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let worker = PolypharmacyCriteriaWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = PolypharmacyCriteriaInteractor(presenter: self, worker: worker, cgaId: cgaId)

        let firstExpectation = TestExpectation(description: "Call controllerDidLoad")
        firstExpectation.expectedFulfillmentCount = 2

        currentExpectation = firstExpectation

        interactor.controllerDidLoad()

        let secondExpectation = TestExpectation(description: "Call didSelect single medicine picker row")
        currentExpectation = secondExpectation

        interactor.didSelectPickerRow(identifier: .numberOfMedicines, row: 1)

        wait(for: [saveExpectation, firstExpectation, secondExpectation], timeout: 1)
    }

    func testDidSelectMultipleMedicinePickerRow() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let worker = PolypharmacyCriteriaWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = PolypharmacyCriteriaInteractor(presenter: self, worker: worker, cgaId: cgaId)

        let firstExpectation = TestExpectation(description: "Call controllerDidLoad")
        firstExpectation.expectedFulfillmentCount = 2

        currentExpectation = firstExpectation

        interactor.controllerDidLoad()

        let secondExpectation = TestExpectation(description: "Call didSelect multiple medicine picker row")
        currentExpectation = secondExpectation

        interactor.didSelectPickerRow(identifier: .numberOfMedicines, row: 5)

        wait(for: [saveExpectation, firstExpectation, secondExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = TestExpectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = PolypharmacyCriteriaWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = PolypharmacyCriteriaInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didSelectPickerRow(identifier: nil, row: 2)

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - PolypharmacyCriteriaPresentationLogic extension

extension PolypharmacyCriteriaInteractorTests: PolypharmacyCriteriaPresentationLogic {
    func route(toRoute route: PolypharmacyCriteriaModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .polypharmacyCriteria, results: .init(numberOfMedicines: 3), cgaId: cgaId))
        case "Call didTap picker":
            XCTAssertEqual(route, .openBottomSheet(viewModel: .init(
                                                    pickerContent: Array(0...100).map({ "\($0) \($0 == 1 ? LocalizedTable.medicineSingular.localized : LocalizedTable.medicinePlural.localized)" }),
                                                    identifier: .numberOfMedicines, delegate: nil, selectedRow: 0)))
        case "Call didTap picker single medicine":
            XCTAssertEqual(route, .openBottomSheet(viewModel: .init(
                                                    pickerContent: Array(0...100).map({ "\($0) \($0 == 1 ? LocalizedTable.medicineSingular.localized : LocalizedTable.medicinePlural.localized)" }),
                                                    identifier: .numberOfMedicines, delegate: nil, selectedRow: 1)))
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: PolypharmacyCriteriaModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(viewModel.picker.pickerValue, "3 medicamentos")
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
        case "Call didSelect single medicine picker row", "Call didTap picker single medicine":
            XCTAssertEqual(viewModel.picker.pickerValue, "1 medicamento")
        case "Call didSelect multiple medicine picker row":
            XCTAssertEqual(viewModel.picker.pickerValue, "5 medicamentos")
        case "Call update invalid":
            XCTAssertEqual(viewModel.picker.pickerValue, "2 medicamentos")
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }
}
