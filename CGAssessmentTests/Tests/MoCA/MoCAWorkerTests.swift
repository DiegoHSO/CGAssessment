//
//  MoCAWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class MoCAWorkerTests: XCTestCase {

    // MARK: - Private Properties

    private var currentExpectation: XCTestExpectation?
    private var dao: CoreDataDAOMock?

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

    func testGetAssessmentProgress() {
        let newExpectation = expectation(description: "Call getAssessmentProgress")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = MoCAWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let test = try worker.getMoCAProgress()

            guard let binaryOptions = test?.binaryOptions?.allObjects as? [BinaryOption] else {
                XCTFail("Unable to get selectable options for test")
                return
            }

            var rawBinaryQuestions: MoCAModels.RawBinaryQuestions = [:]

            binaryOptions.forEach { option in
                guard let selectedOption = SelectableBinaryKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.sectionId ?? "") else { return }
                if rawBinaryQuestions[identifier] == nil { rawBinaryQuestions[identifier] = [:] }
                rawBinaryQuestions[identifier]?.updateValue(selectedOption, forKey: option.optionId)
            }

            XCTAssertEqual(rawBinaryQuestions, [.visuospatial: [1: .yes, 2: .not, 3: .yes, 4: .yes, 5: .yes],
                                                .naming: [1: .not, 2: .yes, 3: .yes],
                                                .mocaFourthSectionSecondInstruction: [1: .yes, 2: .yes],
                                                .mocaFourthSectionThirdInstruction: [1: .yes],
                                                .mocaFourthSectionFourthInstruction: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                .language: [1: .yes, 2: .not],
                                                .abstraction: [1: .yes, 2: .yes],
                                                .delayedRecall: [1: .yes, 2: .yes, 3: .not, 4: .yes, 5: .yes],
                                                .orientation: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes, 6: .yes]])

            XCTAssertEqual(test?.selectedOption, 1)
            XCTAssertEqual(test?.countedWords, 14)
            XCTAssertNil(test?.watchImage)
            XCTAssertNil(test?.circlesImage)
            XCTAssertEqual(test?.isDone, true)
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [newExpectation], timeout: 1)
    }

    func testSaveAssessmentProgress() {
        let saveExpectation = expectation(forNotification: .NSManagedObjectContextDidSave, object: dao?.context) { _ in
            return true
        }

        let newExpectation = expectation(description: "Call saveAssessmentProgress")
        currentExpectation = newExpectation

        guard let cgaId = UUID(uuidString: "0734772b-cd5b-4392-9148-7bf1994dd8d3") else {
            XCTFail("Unexpected UUID")
            return
        }

        let worker = MoCAWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            try worker.updateMoCAProgress(with: .init(binaryQuestions: [.visuospatial: [1: .not, 2: .not, 3: .not, 4: .not, 5: .not],
                                                                        .naming: [1: .not, 2: .not, 3: .not],
                                                                        .mocaFourthSectionSecondInstruction: [1: .not, 2: .not],
                                                                        .mocaFourthSectionThirdInstruction: [1: .yes],
                                                                        .mocaFourthSectionFourthInstruction: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                        .language: [1: .yes, 2: .yes],
                                                                        .abstraction: [1: .yes, 2: .yes],
                                                                        .delayedRecall: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes],
                                                                        .orientation: [1: .yes, 2: .yes, 3: .yes, 4: .yes, 5: .yes, 6: .yes]],
                                                      selectedEducationOption: .secondOption,
                                                      countedWords: 120, circlesImage: Data(),
                                                      watchImage: Data(), isDone: false))
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }
}
