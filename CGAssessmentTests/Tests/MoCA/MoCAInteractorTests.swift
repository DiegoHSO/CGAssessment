//
//  MoCAInteractorTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 02/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment
import PhotosUI

final class MoCAInteractorTests: XCTestCase {

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

        let worker = MoCAWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MoCAInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = MoCAWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MoCAInteractor(presenter: self, worker: worker, cgaId: cgaId)
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

        let worker = MoCAWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MoCAInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .firstOption, value: .miniMentalStateExamFirstQuestion)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidSelectBinaryOption() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didSelect binaryOption")

        currentExpectation = newExpectation

        let worker = MoCAWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MoCAInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(option: .yes, numberIdentifier: 1, sectionIdentifier: .visuospatial)

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testDidUpdateCountedWords() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let worker = MoCAWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MoCAInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didChangeValue(value: 14)

        wait(for: [saveExpectation], timeout: 1)
    }

    func testDidSelectGallery() {
        let newExpectation = TestExpectation(description: "Call didSelect gallery")

        currentExpectation = newExpectation

        let worker = MoCAWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MoCAInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(buttonIdentifier: .gallery)

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidSelectCamera() {
        let newExpectation = TestExpectation(description: "Call didSelect camera")

        currentExpectation = newExpectation

        let worker = MoCAWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MoCAInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(buttonIdentifier: .takePhoto)

        wait(for: [newExpectation], timeout: 1)
    }

    func testSelectInvalidOption() {
        let newExpectation = TestExpectation(description: "Call didSelect invalid option")

        currentExpectation = newExpectation

        let worker = MoCAWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MoCAInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didSelect(buttonIdentifier: .none)

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }

    func testDidCaptureImage() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = TestExpectation(description: "Call didCapture image")
        newExpectation.expectedFulfillmentCount = 2

        currentExpectation = newExpectation

        let worker = MoCAWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MoCAInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.didCaptureImage(image: UIImage(systemName: "eraser.fill"))
        interactor.didCaptureImage(image: UIImage(systemName: "eraser.fill"))

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }

    func testUpdateAssessmentWithInvalidCGA() {
        let newExpectation = TestExpectation(description: "Call update invalid")
        currentExpectation = newExpectation

        let worker = MoCAWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: UUID())

        let interactor = MoCAInteractor(presenter: self, worker: worker, cgaId: UUID())
        interactor.didSelect(option: .secondOption, value: .miniMentalStateExamFirstQuestion)

        wait(for: [newExpectation], timeout: 1)
    }

    func testSelectPickerDelegate() {
        let newExpectation = TestExpectation(description: "Call didSelect picker delegate")

        currentExpectation = newExpectation

        let worker = MoCAWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        let interactor = MoCAInteractor(presenter: self, worker: worker, cgaId: cgaId)
        interactor.picker(PHPickerViewController(configuration: .init()), didFinishPicking: [])

        currentExpectation?.fulfill()

        wait(for: [newExpectation], timeout: 1)
    }
}

// MARK: - MoCAPresentationLogic extension

extension MoCAInteractorTests: MoCAPresentationLogic {
    func route(toRoute route: MoCAModels.Routing) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertEqual(route, .testResults(test: .moca, results: .init(binaryQuestions: [.visuospatial: [1: .yes, 2: .not, 3: .yes, 4: .yes, 5: .yes],
                                                                                             .naming: [1: .not, 2: .yes, 3: .yes],
                                                                                             .mocaFourthSectionSecondInstruction: [1: .yes, 2: .yes],
                                                                                             .mocaFourthSectionThirdInstruction: [1: .yes],
                                                                                             .mocaFourthSectionFourthInstruction: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                                             .language: [1: .yes, 2: .not],
                                                                                             .abstraction: [1: .yes, 2: .yes],
                                                                                             .delayedRecall: [1: .yes, 2: .yes, 3: .not, 4: .yes, 5: .yes],
                                                                                             .orientation: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes, 6: .yes]],
                                                                           selectedEducationOption: .firstOption, countedWords: 14), cgaId: cgaId))
        case "Call didSelect gallery":
            XCTAssertEqual(route, .imagePicker(configuration: .init(), delegate: nil))
        case "Call didSelect camera":
            XCTAssertEqual(route, .camera)
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func presentData(viewModel: MoCAModels.ControllerViewModel) {
        switch currentExpectation?.description {
        case "Call controllerDidLoad", "Call didTap action button":
            XCTAssertTrue(viewModel.isResultsButtonEnabled)
            XCTAssertTrue(viewModel.selectedOption == .firstOption)
            XCTAssertTrue(viewModel.countedWords == 14)
            XCTAssertEqual(viewModel.binaryQuestions.allSatisfy({ $0.value.allSatisfy({ $0.value?.options.allSatisfy { $0.value != .none } ?? false }) }), true)
            XCTAssertNil(viewModel.watchImage)
            XCTAssertNil(viewModel.circlesImage)
        case "Call didSelect binaryOption":
            guard let valueDict = viewModel.binaryQuestions[.visuospatial], let value = valueDict.first(where: { $0.value?.sectionIdentifier == .visuospatial })?.value else {
                XCTFail("Couldn't find selected option for question")
                return
            }
            XCTAssertEqual(value.options[1], .yes)
        case "Call didSelect option":
            XCTAssertTrue(viewModel.selectedOption == .firstOption)
        case "Call update invalid":
            XCTAssertEqual(viewModel.binaryQuestions.allSatisfy({ $0.value.allSatisfy({ $0.value?.options.allSatisfy { $0.value == .none } ?? false }) }), true)
        case "Call didCapture image":
            if currentExpectation?.currentFulfillmentCount == 0 {
                XCTAssertNotNil(viewModel.circlesImage)
                XCTAssertNil(viewModel.watchImage)
            } else {
                XCTAssertNotNil(viewModel.circlesImage)
                XCTAssertNotNil(viewModel.watchImage)
            }
        default:
            XCTFail("Unexpected description: \(currentExpectation?.description ?? "<nil>")")
        }

        currentExpectation?.fulfill()
    }

    func dismissPresentingController() {
        XCTAssertEqual(currentExpectation?.description, "Call didSelect picker delegate")
        currentExpectation?.fulfill()
    }
}
