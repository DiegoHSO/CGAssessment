//
//  MiniMentalStateExamWorkerTests.swift
//  CGAssessmentTests
//
//  Created by Diego Henrique Silva Oliveira on 01/11/23.
//

import CoreData
import XCTest
@testable import CGAssessment

final class MiniMentalStateExamWorkerTests: XCTestCase {

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

        let worker = MiniMentalStateExamWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            let test = try worker.getMiniMentalStateExamProgress()

            guard let binaryOptions = test?.binaryOptions?.allObjects as? [BinaryOption],
                  let questionOptions = test?.selectableOptions?.allObjects as? [SelectableOption] else {
                XCTFail("Unable to get selectable options for test")
                return
            }

            var rawQuestions: MiniMentalStateExamModels.RawQuestions = [:]
            var rawBinaryQuestions: MiniMentalStateExamModels.RawBinaryQuestions = [:]

            questionOptions.forEach { option in
                guard let selectedOption = SelectableKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.identifier ?? "") else { return }
                rawQuestions[identifier] = selectedOption
            }

            binaryOptions.forEach { option in
                guard let selectedOption = SelectableBinaryKeys(rawValue: option.selectedOption),
                      let identifier = LocalizedTable(rawValue: option.sectionId ?? "") else { return }
                if rawBinaryQuestions[identifier] == nil { rawBinaryQuestions[identifier] = [:] }
                rawBinaryQuestions[identifier]?.updateValue(selectedOption, forKey: option.optionId)
            }

            XCTAssertEqual(rawQuestions, [.miniMentalStateExamFirstQuestion: .secondOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                          .miniMentalStateExamThirdQuestion: .secondOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                          .miniMentalStateExamFifthQuestion: .firstOption])

            XCTAssertEqual(rawBinaryQuestions, [.miniMentalStateExamFirstSectionQuestion: [1: .yes, 2: .not, 3: .not, 4: .yes, 5: .yes],
                                                .miniMentalStateExamSecondSectionQuestion: [1: .not, 2: .yes, 3: .yes, 4: .yes, 5: .not],
                                                .miniMentalStateExamThirdSectionQuestion: [1: .not, 2: .yes, 3: .yes],
                                                .miniMentalStateExamFourthSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .not, 5: .not],
                                                .miniMentalStateExamFifthSectionQuestion: [1: .yes, 2: .not, 3: .yes],
                                                .miniMentalStateExamSixthSectionQuestion: [1: .yes, 2: .yes],
                                                .miniMentalStateExamSeventhSectionQuestion: [1: .yes, 2: .yes, 3: .not]])

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

        let worker = MiniMentalStateExamWorker(dao: dao ?? DAOFactory.coreDataDAO, cgaId: cgaId)

        do {
            try worker.updateMiniMentalStateExamProgress(with: .init(questions: [.miniMentalStateExamFirstQuestion: .firstOption, .miniMentalStateExamSecondQuestion: .firstOption,
                                                                                 .miniMentalStateExamThirdQuestion: .firstOption, .miniMentalStateExamFourthQuestion: .firstOption,
                                                                                 .miniMentalStateExamFifthQuestion: .thirdOption],
                                                                     binaryQuestions: [.miniMentalStateExamFirstSectionQuestion: [1: .not, 2: .not, 3: .not, 4: .yes, 5: .yes],
                                                                                       .miniMentalStateExamSecondSectionQuestion: [1: .not, 2: .yes, 3: .yes, 4: .yes, 5: .not],
                                                                                       .miniMentalStateExamThirdSectionQuestion: [1: .yes, 2: .yes, 3: .yes],
                                                                                       .miniMentalStateExamFourthSectionQuestion: [1: .yes, 2: .yes, 3: .yes, 4: .not, 5: .not],
                                                                                       .miniMentalStateExamFifthSectionQuestion: [1: .yes, 2: .not, 3: .yes],
                                                                                       .miniMentalStateExamSixthSectionQuestion: [1: .none, 2: .yes],
                                                                                       .miniMentalStateExamSeventhSectionQuestion: [1: .yes, 2: .yes, 3: .not]], isDone: true))
            currentExpectation?.fulfill()
        } catch {
            XCTFail("Test failed with error \(error.localizedDescription)")
        }

        wait(for: [saveExpectation, newExpectation], timeout: 1)
    }
}
